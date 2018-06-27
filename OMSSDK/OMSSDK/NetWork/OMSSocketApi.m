//
//  SWMessageClient.m
//  LSSDK
//
//  Created by Sunniwell on 12/30/16.
//  Copyright © 2016 Sunniwell. All rights reserved.
//

#import "OMSSocketApi.h"
#import <GCDAsyncSocket.h>
#import "OMSError.h"
#import <Reachability.h>

#define SOCKETTIMEOUT 10

#define HTTP_HEADER_GET(str) [NSString stringWithFormat:@"GET %@ HTTP/1.1\r\n",str];

#define HTTP_HEADER_POST(str) [NSString stringWithFormat:@"POST %@ HTTP/1.1\r\n",str];

#define HTTP_HEADER_LENGTH(length) [NSString stringWithFormat:@"Content-Length:%ld\r\n",length];

#define HTTP_HEADER_HOST(host,port) [NSString stringWithFormat:@"Host:%@:%ld\r\nConnection:Keep-Alive\r\nCache-Control: no-cache\r\n\r\n",host,port];

#define HTTP_HEADER_SESSIONID(sessionId) [NSString stringWithFormat:@"SessionId:%lld\r\n",sessionId];

#define HTTP_HEADER_SIGN(UIN, SIGN, Timestamp, Random, Token) [NSString stringWithFormat:@"UIN: %@\r\nSign: %@\r\nTimestamp: %@\r\nRandom: %@\r\nToken: %@\r\n",UIN, SIGN, Timestamp, Random, Token]

static NSString *headerEndStr = @"\n";

static int const pkt_header_length = 6;
static int remain_header_length = 0;
static int body_length = 0;

typedef NS_ENUM(NSInteger,ReadType) {
    ReadType_Length = 1,
    ReadType_Header,
    ReadType_Body,
};


@implementation OMSSocketRequestMap

@end

@interface OMSSocketApi()<GCDAsyncSocketDelegate>

@property (nonatomic,strong) GCDAsyncSocket *gcdsocket;
@property (nonatomic, strong) dispatch_queue_t socketQueue;//gcd数据返回队列

@property (nonatomic, strong) NSMutableDictionary *requestsMap;
@property (nonatomic, strong) NSString *serverDomain;
@property (nonatomic, assign) int port;
@property (nonatomic, assign) NSTimeInterval lastReadTime;
@property (atomic, assign) long long sessionId;
@property (atomic, assign) long long seqId;
@property (nonatomic, assign) BOOL needReconnect;//是否失败重连 默认开启 只有外部明确停止socket时不重新连接
@property (nonatomic, copy)OMSSocketStatusBlock statusBlock;
@property (nonatomic, assign) BOOL isNetworkDown;//当前网络状态
    
@property (nonatomic, strong) dispatch_queue_t toolsQueue;
@property (nonatomic, assign) void *IsOnToolsQueueOrTargetQueueKey;
@property (nonatomic, strong) Reachability *hostReachability;
@property (nonatomic, strong) Reachability *routerReachability;

@property (nonatomic, assign)uint32_t omsCmd;

@end

@implementation OMSSocketApi

+ (OMSSocketApi *)sharedInstance {
    static OMSSocketApi *instance;     
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[OMSSocketApi alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化部分
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.seqId = 10;//从11开始
            [self connectToHost:kOMSDefaultConfigs.socketHost onPort:[kOMSDefaultConfigs.socketPort integerValue] error:nil];
            [self performSelectorOnMainThread:@selector(startMonitoringNetwork) withObject:nil waitUntilDone:NO];
        });
    }
    return self;
}

#pragma mark 数据初始化
//socket
- (GCDAsyncSocket *)gcdsocket {
    if (!_gcdsocket) {
        _gcdsocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketQueue];
        [_gcdsocket setIPv4PreferredOverIPv6:NO];
    }
    return _gcdsocket;
}

//请求存放block字典
- (NSMutableDictionary *)requestsMap {
    if (!_requestsMap) {
        _requestsMap = [NSMutableDictionary dictionary];
    }
    return _requestsMap;
}

//结果输出队列 可以由外面指定
- (dispatch_queue_t)delegateQueue {
    if (!_delegateQueue) {
        _delegateQueue =  dispatch_queue_create("oms.gcd.socket.delegate.queue", DISPATCH_QUEUE_SERIAL);
    }
    return _delegateQueue;
}

//gcd结果队列
- (dispatch_queue_t)socketQueue {
    if (!_socketQueue) {
        _socketQueue =  dispatch_queue_create("oms.gcd.socket.concurrent.queue", DISPATCH_QUEUE_SERIAL);
    }
    return _socketQueue;
}

//处理结果队列
- (dispatch_queue_t)toolsQueue {
    if (!_toolsQueue) {
        _toolsQueue =  dispatch_queue_create("oms.gcd.socket.toolsQueue.queue", DISPATCH_QUEUE_SERIAL);
        _IsOnToolsQueueOrTargetQueueKey = &_IsOnToolsQueueOrTargetQueueKey;
        void *nonNullUnusedPointer = (__bridge void *)self;
        dispatch_queue_set_specific(_socketQueue, _IsOnToolsQueueOrTargetQueueKey, nonNullUnusedPointer, NULL);
    }
    return _toolsQueue;
}

#pragma mark 外部方法
- (BOOL)connectToHost:(NSString *)host onPort:(uint16_t)port error:(NSError *__autoreleasing *)errPtr {
    return [self connectToHost:host onPort:port withTimeout:-1 error:errPtr];
}

- (BOOL)connectToHost:(NSString *)host onPort:(uint16_t)port withTimeout:(NSTimeInterval)timeout error:(NSError *__autoreleasing *)errPtr {
    OMSLogW(@"Socket connect to Host %@, Port", host, port);
    self.needReconnect = YES;
    self.connectStatus = 0;
    self.serverDomain = host;
    self.port = port;
    return [self.gcdsocket connectToHost:host onPort:port withTimeout:timeout error:errPtr];
}

- (void)socketWriteDataWithMethod:(OMSSocketMethod)method RequestPath:(NSString *)path RequestBody:(NSString *)body RequestHeader:(NSDictionary *)header completion:(OMSSocketDidReadBlock)completion {
    if (self.connectStatus == -1) {
        OMSLogW(@"socket 未连通");
        if (completion) {
            completion([OMSError errorWithErrorCode:OMSErrorCode_NETWORK_DISCONNECTED],
                     nil);
        }
        return;
    }
    long blockRequestID = (long)[self createRequestID];
    if (completion) {
        OMSSocketRequestMap *socketMap =[[OMSSocketRequestMap alloc] init];
        socketMap.isUsed = false;
        socketMap.completion = completion;
        [self.requestsMap setObject:socketMap forKey:@(blockRequestID).stringValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(checkWriteResult:) withObject:@(blockRequestID).stringValue afterDelay:SOCKETTIMEOUT];
        });
    }
    NSData *senddata = [self createHttpContentWithMethod:method SessionID:blockRequestID path:path body:body header:header];
    [self.gcdsocket writeData:senddata withTimeout:SOCKETTIMEOUT tag:blockRequestID];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (now - self.lastReadTime > SOCKETTIMEOUT * 6) {
        [self beginReadData];//打破socket等待
    }
}

- (void)socketWriteDataWithMessage:(OMSMessage *)message completion:(OMSSocketDidReadBlock)completion{
    if (self.connectStatus == -1) {
        OMSLogW(@"socket 未连通");
        if (completion) {
            completion([OMSError errorWithErrorCode:OMSErrorCode_NETWORK_DISCONNECTED],
                       nil);
        }
        return;
    }
//    long blockRequestID = (long)[self createRequestID];
    long blockRequestID = message.mHead.mSessionId;
    if (completion) {
        OMSSocketRequestMap *socketMap =[[OMSSocketRequestMap alloc] init];
        socketMap.isUsed = false;
        socketMap.completion = completion;
        [self.requestsMap setObject:socketMap forKey:@(blockRequestID).stringValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(checkWriteResult:) withObject:@(blockRequestID).stringValue afterDelay:SOCKETTIMEOUT];
        });
    }
    [self.gcdsocket writeData:message.getDataBytes withTimeout:SOCKETTIMEOUT tag:blockRequestID];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (now - self.lastReadTime > SOCKETTIMEOUT * 6) {
        [self beginReadData];//打破socket等待
    }
}

- (void)disconnect {
    self.needReconnect = NO;
    [self disconnectSocket];
}

-(void)socketStatusChange:(OMSSocketStatusBlock)statusBlock
{
    _statusBlock = statusBlock;
}
- (void)dealWithNetwork:(BOOL)isNetWorkDown
{
    if (isNetWorkDown) {
        self.isNetworkDown = isNetWorkDown;
        if (self.needReconnect && self.connectStatus != -1) {
            [self disconnectSocket];
        }
    }else{
        if (!self.isNetworkDown) {
            return;
        }
        self.isNetworkDown = isNetWorkDown;
        [self reconnectSocket];
    }

}
#pragma mark - GCDSocket代理

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    self.connectStatus = 1;
    if (_delegate && [_delegate respondsToSelector:@selector(OnSocketConnectSuccess:port:)]) {
        [_delegate OnSocketConnectSuccess:host port:port];
    }
    [self beginReadData];
    if (_statusBlock) {
        _statusBlock(YES);
    }
    OMSLogD(@"connect success to host %@,port %d",host,port);
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    self.connectStatus = -1;
    if (_delegate && [_delegate respondsToSelector:@selector(OnSocketDisConnect:)]) {
        [_delegate OnSocketDisConnect:err];
    }
    [self reconnectSocket:1];
    
    if (_statusBlock) {
        _statusBlock(NO);
    }
    OMSLogD(@"socket disconnect with error %@", err);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
    if (tag == ReadType_Length) {
        //读取头部的长度
        Byte *byte = (Byte *)[data bytes];
        uint32_t pktLenth;
        
        pktLenth = [self bytesToIntBig:byte offset:0];
        remain_header_length = [self bytesToShortBig:byte offset:4];
        body_length = pktLenth - remain_header_length;
        [self.gcdsocket readDataToLength:remain_header_length-6 withTimeout:-1 tag:ReadType_Header];
    }
    else if (tag == ReadType_Header) {
        //解析head
        Byte *mHeadByte = (Byte *)[data bytes];
        _omsCmd = [self bytesToIntBig:mHeadByte offset:2];
        _sessionId = [self bytesToIntBig:mHeadByte offset:6];
        [self.gcdsocket readDataToLength:body_length withTimeout:-1 tag:ReadType_Body];
    }
    else if(tag == ReadType_Body) {
        
        [self dispatchOnToolsQueue:^{
            NSNumber *sessionId = [NSNumber numberWithInteger:_sessionId];
            OMSSocketRequestMap *map = self.requestsMap[sessionId.stringValue];
            if (map) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkWriteResult:) object:sessionId.stringValue];//取到结果，取消当前请求
                });
                
                if (!map.isUsed) {
                    map.isUsed = true;
                    dispatch_async(self.delegateQueue, ^{
                        OMSSocketDidReadBlock completion = map.completion;
                        if (completion) {
                            completion(nil, data);
                        }
                        [self.requestsMap removeObjectForKey:sessionId.stringValue];
                    });
                }
            }else {
                dispatch_async(self.delegateQueue, ^{
//                    if (_delegate && [_delegate respondsToSelector:@selector(OnReceiveServerMsg:)]) {
//                        [_delegate OnReceiveServerMsg:data];
//                    }
                    if (_delegate && [_delegate respondsToSelector:@selector(OnReceiveServerMsg:omsCmd:omsSessionId:)]) {
                        [_delegate OnReceiveServerMsg:data omsCmd:_omsCmd omsSessionId:_sessionId];
                    }
                });
                
            }
        } async:NO];
        
        [self beginReadData];
    }
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length {
    
    [self dispatchOnToolsQueue:^{
        OMSSocketRequestMap *map = self.requestsMap[@(tag).stringValue];
        if (map) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkWriteResult:) object:@(tag).stringValue];//取到结果，取消预执行请求
            });
            
            if (!map.isUsed) {
                map.isUsed = true;
                dispatch_async(self.delegateQueue, ^{
                    OMSSocketDidReadBlock completion = map.completion;
                    if (completion) {
                        NSError *error = [OMSError errorWithErrorCode:OMSErrorCode_REQUEST_TIMEOUT];
                        completion(error,nil);
                    }
                    [self.requestsMap removeObjectForKey:@(tag).stringValue];
                });
                
            }
        }
    } async:NO];
    return -1;
}

#pragma mark 私有接口

- (void)checkWriteResult:(NSString *)requestIdKey
{
    //    NSLog(@"checkWriteResult: %@",requestIdKey);
    [self dispatchOnToolsQueue:^{
        OMSSocketRequestMap *map = self.requestsMap[requestIdKey];
        if (map && !map.isUsed) {
            map.isUsed = true;
            dispatch_async(self.delegateQueue, ^{
                OMSSocketDidReadBlock completion = map.completion;
                if (completion) {
                    NSError *error = [OMSError errorWithErrorCode:OMSErrorCode_REQUEST_TIMEOUT];
                    completion(error, nil);
                }
                [self.requestsMap removeObjectForKey:requestIdKey];
            });
            
        }
    } async:NO];
}

- (long long)createRequestID {
    //NSInteger timeInterval = [NSDate date].timeIntervalSince1970 * 1000000;
    //NSString *randomRequestID = [NSString stringWithFormat:@"%ld%d", timeInterval, arc4random() % 100000];
//    return randomRequestID;
    _seqId++;
    return _seqId;
}

- (void)beginReadData {
    [self.gcdsocket readDataToLength:pkt_header_length withTimeout:-1 tag:ReadType_Length];
    self.lastReadTime = [[NSDate date] timeIntervalSince1970];
}

- (void)beginReadDataWithLength:(long)length {
    if (length > 0) {
        [self.gcdsocket readDataToLength:length withTimeout:-1 tag:ReadType_Body];
        self.lastReadTime = [[NSDate date] timeIntervalSince1970];
//        LSLogD(@"begin read length is %ld,time is %f", length,self.lastReadTime);
    }
    else{
        [self beginReadData];
    }
}

- (NSInteger)obtainContentLength:(NSString *)response {
    response = [response stringByReplacingOccurrencesOfString:headerEndStr withString:@""];
    NSRange range = [response rangeOfString:@"Content-Length:"];
    if (range.length > 0) {
        response = [response substringFromIndex:range.location + range.length];
        
    }
    range = [response rangeOfString:@"\r\n"];
    if (range.length > 0) {
        response = [response substringToIndex:range.location];
        
    }
    response = [response stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger length = 0;
    if ([self isPureInt:response]) {
        length = [response integerValue];
    }
    return length;
    
}

- (NSInteger)getStatusCode:(NSString *)response
{
    NSInteger statusCode = -1;
    if (response && [response rangeOfString:@"HTTP/1.1"].length > 0) {
        NSRange range = [response rangeOfString:@"\r\n"];
        NSString *statusStr = [response substringToIndex:range.location];
        NSArray *tmpArray = [statusStr componentsSeparatedByString:@" "];
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSString *str in tmpArray) {
            if (str.isNonEmptyString) {
                [dataArray addObject:str];
            }
        }
        if ([dataArray count] >= 2) {
            statusCode = [dataArray[1] integerValue];
        }
    }
    return statusCode;
}

- (NSInteger)getSessionId:(NSString *)rawStr {
    NSRange range = [rawStr rangeOfString:@"\r\n"];
    if (range.location > 0) {
        rawStr =[rawStr substringToIndex:range.location];
    }
    rawStr = [rawStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger length = 0;
    if ([self isPureInt:rawStr]) {
        length = [rawStr integerValue];
    }
    return length;
    
}
- (BOOL)isPureInt:(NSString*)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (void)startMonitoringNetwork {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appReachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    // 检测默认路由是否可达
    self.routerReachability = [Reachability reachabilityForInternetConnection];
    [self.routerReachability startNotifier];
}
/// 当网络状态发生变化时调用
- (void)appReachabilityChanged:(NSNotification *)notification{
    Reachability *reach = [notification object];
    if([reach isKindOfClass:[Reachability class]]){
        NetworkStatus status = [reach currentReachabilityStatus];
        // 两种检测:路由与服务器是否可达  三种状态:手机流量联网、WiFi联网、没有联网
        if (reach == self.routerReachability) {
            if (status == NotReachable) {
                self.isNetworkDown = YES;
                if (self.needReconnect && self.connectStatus != -1) {
                    [self disconnectSocket];
                }
            } else if (status == ReachableViaWiFi || status == ReachableViaWWAN) {
                if (self.isNetworkDown) {
                    self.isNetworkDown = NO;
                    [self reconnectSocket];
                }
            }
        }
    }
    
//    AFNetworkReachabilityManager *networkManager = [AFNetworkReachabilityManager sharedManager];
//    [networkManager startMonitoring];
//    __weak __typeof(&*self) weakSelf = self;
//    [networkManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case AFNetworkReachabilityStatusNotReachable:
//                weakSelf.isNetworkDown = YES;
//                if (weakSelf.needReconnect && weakSelf.connectStatus != -1) {
//                    [weakSelf disconnectSocket];
//                }
//                break;
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//            case AFNetworkReachabilityStatusReachableViaWiFi:{
//                if (weakSelf.isNetworkDown) {
//                    weakSelf.isNetworkDown = NO;
//                    [weakSelf reconnectSocket];
//                }
//
//            }
//                break;
//            default:
//                break;
//        }
//    }];
}

- (void)reconnectSocket:(NSTimeInterval)delayTime {
    if (self.needReconnect && self.connectStatus == -1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayTime * NSEC_PER_SEC), _delegateQueue, ^{
            [self reconnectSocket];
        });
    }
}

- (void)reconnectSocket {
    OMSLogD(@"-------reconnectSocket--------");
    if (self.isNetworkDown) {
        return;
    }
    if (self.needReconnect && self.connectStatus == -1) {
        [self connectToHost:self.serverDomain onPort:self.port error:nil];
    }
}

- (void)disconnectSocket {
    self.connectStatus = -1;
    [self.gcdsocket setDelegate:nil];
    if ([self.gcdsocket isConnected]) {
        [self.gcdsocket disconnect];
    }
    self.gcdsocket = nil;
}

- (BOOL)isOnToolsQueue
{
    return dispatch_get_specific(_IsOnToolsQueueOrTargetQueueKey) != NULL;
}

- (void)dispatchOnToolsQueue:(dispatch_block_t)block async:(BOOL)async
{
    if ([self isOnToolsQueue]) {
        @autoreleasepool {
            block();
        }
        return;
    }
    
    if (async) {
        dispatch_async([self toolsQueue], ^{
            @autoreleasepool {
                block();
            }
        });
        return;
    }
    
    dispatch_sync([self toolsQueue], ^{
        @autoreleasepool {
            block();
        }
    });
}

- (NSData *)createHttpContentWithMethod:(OMSSocketMethod)method SessionID:(long long)SessionId path:(NSString *)path body:(NSString *)body header:(NSDictionary *)header{
    //认证之类 服务器需要验证的东西 在此处添加
    NSString *infoStr = @"Accept: */*\r\nUser-Agent: iPhone\r\nContent-Type: application/x-www-form-urlencoded;charset=UTF-8\r\n";
    NSString *msgStr = @"";
    switch (method) {
        case OMS_SOCKET_METHOD_GET:{
            NSString *requsetStr = path;
            if (body) {
                requsetStr = [NSString stringWithFormat:@"%@?%@",path,body];
            }

            NSString *getStr = HTTP_HEADER_GET(requsetStr);
            NSString *sessionId = HTTP_HEADER_SESSIONID(SessionId);
            NSString *signStr = header?HTTP_HEADER_SIGN(header[@"UIN"], header[@"Sign"], header[@"Timestamp"], header[@"Random"], header[@"Token"]):@"";
            NSString *hostStr = HTTP_HEADER_HOST(self.serverDomain, (long)self.port);
            msgStr = [NSString stringWithFormat:@"%@%@%@%@%@",
                      getStr,infoStr,sessionId,signStr,hostStr];
        }
            break;
        case OMS_SOCKET_METHOD_POST:{
            NSString *postStr = HTTP_HEADER_POST(path);
            NSString *lengthStr = HTTP_HEADER_LENGTH((unsigned long)body.length);
            NSString *sessionId = HTTP_HEADER_SESSIONID(SessionId);
            NSString *signStr = header?HTTP_HEADER_SIGN(header[@"UIN"], header[@"Sign"], header[@"Timestamp"], header[@"Random"], header[@"Token"]):@"";
            NSString *hostStr = HTTP_HEADER_HOST(self.serverDomain, (long)self.port);
            msgStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                      postStr,infoStr,
                      lengthStr,sessionId,signStr,hostStr,body];
        }
        default:
            break;
    }
    
//    LSLogD(@"Socket Request Message :\n%@", msgStr);
    return [[NSData alloc] initWithData:[msgStr dataUsingEncoding:NSUTF8StringEncoding]];
}

/**
 * 以大端模式将byte转成int
 */
- (uint32_t)bytesToIntBig:(Byte *)src offset:(uint32_t)offset{
    uint32_t value;
    value = (uint32_t) (((src[offset] & 0xFF) << 24)
                       | ((src[offset + 1] & 0xFF) << 16)
                       | ((src[offset + 2] & 0xFF) << 8)
                       | (src[offset + 3] & 0xFF));
    return value;
}

- (uint16_t)bytesToShortBig:(Byte *)src offset:(uint32_t)offset{
    uint16_t value;
    value = (uint16_t) (((src[offset + 0] & 0xFF) << 8)
                        | (src[offset + 1] & 0xFF));
    return value;
}

- (BOOL)checkCMD:(int)mCmd{
    BOOL isCmd = false;
    switch (mCmd) {
        case 10000: //登录
        case 10001: //心跳
        case 10003: //日志上报
        case 1000:  //监测
        case 1001:{ //自检
            isCmd = YES;
        }
            break;
        default:
            break;
    }
    return isCmd;
}

@end














