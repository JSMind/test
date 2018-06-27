//
//  OMSLogApi.m
//  OMSSDK
//
//  Created by OS_HJS on 2017/8/2.
//  Copyright © 2017年 sunniwell. All rights reserved.
//

#import "OMSLogApi.h"

static NSString *const oms_dir_log_service_server_get = @"/service/server/get";
NSString * const OMSLogApiLockKey = @"com.oms.omslogapi.key";
static int const HEARTBEAT_TIME = 60;

void omsUncaughtExceptionHandler(NSException *exception){
    [CATLog logCrash:exception];
}

static dispatch_queue_t oms_log_processing_queue() {
    static dispatch_queue_t oms_log_processing_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        oms_log_processing_queue = dispatch_queue_create("oms.log.concurrent.processing.queue", DISPATCH_QUEUE_SERIAL);
    });
    return oms_log_processing_queue;
}

static dispatch_queue_t oms_log_completion_queue(){
    static dispatch_queue_t oms_log_completion_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        oms_log_completion_queue = dispatch_queue_create("oms.log.concurrent.complection.queue", DISPATCH_QUEUE_SERIAL);
    });
    return oms_log_completion_queue;
}

@interface OMSLogApi ()<OMSSocketDelegate>

@end

@implementation OMSLogApi
{
    dispatch_source_t _heartBeatTimer;
    NSTimer *_mTimer; //心跳
    BOOL _isFirst;
    NSLock *_lock;
}

#pragma mark - Single Instance
+ (id)sharedInstance {
    static OMSLogApi *logApi = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logApi = [[OMSLogApi alloc] init];
    });
    return logApi;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _isFirst = YES;
        NSSetUncaughtExceptionHandler(&omsUncaughtExceptionHandler);
        [CATLog initWithNumberOfDaysToDelete:3];
        [CATLog setLogLevel:CATLevelD];
        [CATLog setR:200 G:200 B:200 forLevel:CATLevelE];
        [OMSLogApi getAccessServer];
        _lock = [[NSLock alloc] init];
        _lock.name = OMSLogApiLockKey;
    }
    return self;
}

+ (void)InitWithBalanceServer:(NSString *)balanceServer
              balanceHttpPort:(NSString *)balanceHttpProt
             balanceHttpsPort:(NSString *)balanceHttpsPort{
    kOMSDefaultConfigs.balanceAddr = balanceServer;
    kOMSDefaultConfigs.balanceHttpPort = balanceHttpProt;
    kOMSDefaultConfigs.balanceHttpsPort = balanceHttpsPort;
    [OMSLogApi sharedInstance];
}

#pragma mark - log 指令
- (void)omsLogin{
    
    OMSLoginContent *content = [OMSLoginContent contentWithTIN:kOMSDefaultConfigs.tin Uin:kOMSDefaultConfigs.uin terminal_type:OMS_TERMINAlTYPE_IOS_PHONE];
    OMS_WEAK_SELF
    OMSLogD(@"====================OMS Login=================================")
    [OMSLogApi login:content completion:^(NSError *error, id data) {
        OMS_STRONG_SELF
        if (!error) {
            [strongSelf backgroundHeartBeatResume];
        }
        else{
            
        }
    }];
}

+ (void)login:(OMSLoginContent *)loginContent completion:(OMSSocketDidReadBlock)complection{
    OMSHead *head = [[OMSHead alloc] init];
    head.mCommand = 10000;
    OMSLoginMessage *message = [[OMSLoginMessage alloc] initWithHead:head content:loginContent];
    [KOMSSocketStack push:message completion:complection];
    [[OMSLogApi sharedInstance] startWork];
}

+ (void)sendHear:(OMSheartContent *)heartContent completion:(OMSSocketDidReadBlock)complection{
    OMSHead *head = [[OMSHead alloc] init];
    head.mCommand = 10001;
    OMSHeartMessage *message = [[OMSHeartMessage alloc] initWithHead:head content:heartContent];
    [KOMSSocketStack push:message completion:complection];
    //立即发送
    [[OMSLogApi sharedInstance] startWork];
}

+ (void)sendDeviceInfo:(OMSDeviceInfoContent *)deviceInfo completion:(OMSSocketDidReadBlock)complection{
    [KOMSSocketStack addCurrentContent:deviceInfo];
}

+ (void)sendDeviceInfoSync:(OMSDeviceInfoContent *)deviceInfo completion:(OMSSocketDidReadBlock)complection{
    //立即发送
    OMSHead *head = [[OMSHead alloc] init];
    head.mCommand = 10003;
    OMSLogMessage *message = [[OMSLogMessage alloc] initWithHead:head content:deviceInfo];
    [KOMSSocketStack push:message completion:complection];
    [[OMSLogApi sharedInstance] startWork];
}

+ (void)sendDeviceStatus:(OMSDeviceStatusContent *)deviceStatus completion:(OMSSocketDidReadBlock)complection{
    [KOMSSocketStack addCurrentContent:deviceStatus];
}

+ (void)sendODeviceStatusSync:(OMSDeviceStatusContent *)deviceStatus completion:(OMSSocketDidReadBlock)complection{
    OMSHead *head = [[OMSHead alloc] init];
    head.mCommand = 10003;
    OMSLogMessage *message = [[OMSLogMessage alloc] initWithHead:head content:deviceStatus];
    [KOMSSocketStack push:message completion:complection];
    [[OMSLogApi sharedInstance] startWork];
}

+ (void)sendPlayStatistics:(OMSPlayStatisticsLogContent *)playStatistics completion:(OMSSocketDidReadBlock)complection{
    [KOMSSocketStack addCurrentContent:playStatistics];
}

+ (void)sendPlayStatisticsSync:(OMSPlayStatisticsLogContent *)playStatistics completion:(OMSSocketDidReadBlock)complection{
    OMSHead *head = [[OMSHead alloc] init];
    head.mCommand = 10003;
    OMSLogMessage *message = [[OMSLogMessage alloc] initWithHead:head content:playStatistics];
    [KOMSSocketStack push:message completion:complection];
    [[OMSLogApi sharedInstance] startWork];
}

+ (void)sendPlayStuck:(OMSPlayStuckLogContent *)playStuck completion:(OMSSocketDidReadBlock)complection{
    [KOMSSocketStack addCurrentContent:playStuck];
}

+ (void)sendPlayStuckSync:(OMSPlayStuckLogContent *)playStuck completion:(OMSSocketDidReadBlock)complection{
    OMSHead *head = [[OMSHead alloc] init];
    head.mCommand = 10003;
    OMSLogMessage *message = [[OMSLogMessage alloc] initWithHead:head content:playStuck];
    [KOMSSocketStack push:message completion:complection];
    [[OMSLogApi sharedInstance] startWork];
}

+ (void)sendPlayError:(OMSPlayErrorLogContent *)playError completion:(OMSSocketDidReadBlock)complection{
    [KOMSSocketStack addCurrentContent:playError];
}

+ (void)sendPlayErrorSync:(OMSPlayErrorLogContent *)playError completion:(OMSSocketDidReadBlock)complection{
    OMSHead *head = [[OMSHead alloc] init];
    head.mCommand = 10003;
    OMSLogMessage *message = [[OMSLogMessage alloc] initWithHead:head content:playError];
    [KOMSSocketStack push:message completion:complection];
    [[OMSLogApi sharedInstance] startWork];
}

+ (void)sendEpgError:(OMSEpgErrorLogContent *)epgError completion:(OMSSocketDidReadBlock)complection{
    [KOMSSocketStack addCurrentContent:epgError];
}

+ (void)sendEpgErrorSync:(OMSEpgErrorLogContent *)epgError completion:(OMSSocketDidReadBlock)complection{
    OMSHead *head = [[OMSHead alloc] init];
    head.mCommand = 10003;
    OMSLogMessage *message = [[OMSLogMessage alloc] initWithHead:head content:epgError];
    [KOMSSocketStack push:message completion:complection];
    [[OMSLogApi sharedInstance] startWork];
}

+ (void)sendSelfCheck:(OMSSelfCheckLogContent *)selfCheck completion:(OMSSocketDidReadBlock)complection{
    [KOMSSocketStack addCurrentContent:selfCheck];
}

+ (void)sendSelfCheckSync:(OMSSelfCheckLogContent *)selfCheck completion:(OMSSocketDidReadBlock)complection{
    OMSHead *head = [[OMSHead alloc] init];
    head.mCommand = 10003;
    OMSLogMessage *message = [[OMSLogMessage alloc] initWithHead:head content:selfCheck];
    [KOMSSocketStack push:message completion:complection];
    [[OMSLogApi sharedInstance] startWork];
}

#pragma mark - public Api
+ (void)setLogLevel:(OMSLogLevel)level{
    switch (level) {
        case OMSLogLevel_Verbose:
            [CATLog setLogLevel:CATLevelV];
            break;
        case OMSLogLevel_Debug:
            [CATLog setLogLevel:CATLevelD];
            break;
        case OMSLogLevel_Info:
            [CATLog setLogLevel:CATLevelI];
            break;
        case OMSLogLevel_Warning:
            [CATLog setLogLevel:CATLevelW];
            break;
        case OMSLogLevel_Error:
            [CATLog setLogLevel:CATLevelE];
            break;
        case OMSLogLevel_None:
            [CATLog setLogLevel:CATLevelN];
            break;
        default:
            [CATLog setLogLevel:CATLevelD];
            break;
    }
}

+ (void)setSendInterval:(NSTimeInterval)sendInterval{
    [KOMSSocketStack setSendInterval:sendInterval];
}

+(NSTimeInterval)getSendInterval{
    return [KOMSSocketStack getSendInterval];
}

#pragma mark - socket
+ (void)setServer:(NSString *)server port:(NSString *)port {
    kOMSDefaultConfigs.socketHost = server;
    kOMSDefaultConfigs.socketPort = port;
}

+ (void)connect {
    KOMSSocketApi;
    [KOMSSocketApi setDelegate:[OMSLogApi sharedInstance]];
}

+ (void)disconnect {
    [KOMSSocketApi disconnect];
}

#pragma mark - OMSSocketDelegate
- (void)OnSocketConnectSuccess:(NSString *)host port:(int)port{
    //连接成功回调，开启定时器
    OMSLogD(@"连接成功，发送OMS登录消息");
    if (_isFirst) {
        _isFirst = NO;
        [self omsLogin];
    }
}

- (void)OnSocketDisConnect:(NSError *)err{
    //断开连接回调
    OMSLogD(@"断开连接:_isFirst=%d", _isFirst);
    _isFirst = YES;
    if (_heartBeatTimer) {
        [self backgroundHeartBeatStop];
    }
}

- (void)OnReceiveServerMsg:(NSData *)data omsCmd:(int)omsCmd omsSessionId:(long long)omsSessionId{
    NSError *error = nil;
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    switch (omsCmd) {
        case 10000:{
            if ([jsonString integerValue] == 0) {
                OMSLogD(@"登录成功");
            }
            else{
                OMSLogD(@"登录失败");
            }
        }
            break;
        case 10001:{
            //心跳
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if ([jsonString intValue] == 0) {
                OMSLogD(@"心跳成功")
            }
            else{
                OMSLogD(@"心跳失败");
            }
        }
            break;
        case 10003: {//日志上报
            OMSLogD(@"播放日志上报成功");
        }
            break;
        case 1000:{  //监测
            OMSLogD(@"监测日志上报成功");
        }
        case 1001:{ //自检
            OMSLogD(@"自检日志上报成功")
        }
            break;
        default:
            break;
    }
    OMSLogD(@"======收到服务器发送的数据:%@%@", jsonString, jsonData);
}

#pragma mark - Private API
- (void)startWork{
     dispatch_async(oms_log_processing_queue(), ^{
         [OMSLogApi checkSocketStatus];
         [_lock lock];
         for (OMSMessage *message in KOMSSocketStack.messageStack) {
             if (message) {
                 [KOMSSocketApi socketWriteDataWithMessage:message completion:^(NSError *error, id data) {
                     OMSSocketDidReadBlock completion = [KOMSSocketStack getCompletionForKey:message.mHead.mSessionId];
                     NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                     NSString *resultStr = nil;
                     if ([jsonString length]>1) {
                         if (message.mHead.mCommand == 10000) {
                             //终端公网IP
                             NSString *publicIP = [jsonString substringFromIndex:1];
                             kOMSDefaultConfigs.wanip = publicIP;
                         }
                         resultStr = [jsonString substringToIndex:1];
                     }
                     if (!error) {
                         OMSLogD(@"消息发送成功:command=%d, sessionId=%d,message:%@", message.mHead.mCommand, message.mHead.mSessionId,message);
                         if (completion) {
                             dispatch_async(oms_log_completion_queue(), ^{
                                completion(error, resultStr);
                             });
                             [KOMSSocketStack removeCompletionForkey:message.mHead.mSessionId];
                         }
                     }
                     else{
                         OMSLogD(@"send error %@", error);
                         completion(error, resultStr);
                     }
                 }];
             }
         }
         [KOMSSocketStack removeAllMessage];
         [_lock unlock];
     });
}

+ (void)getAccessServer{
    [OMSLogApi getAccessServer:^(NSArray *list, NSInteger code, NSString *message) {
        if (code == 0 && list.count > 0) {
            //连接socket
            kOMSDefaultConfigs.accessList = list;
            [KOMSSocketApi connectToHost:kOMSDefaultConfigs.socketHost onPort:[kOMSDefaultConfigs.socketPort integerValue] error:nil];
            [KOMSSocketApi setDelegate:[OMSLogApi sharedInstance]];
        }
        else{
            OMSLogD(@"==getAccessServer list is nil==");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [OMSLogApi getAccessServer];
            });
        }
    }];
}

+ (void)getAccessServer:(OMSListCompletion)completion{
    NSString *requestPath = [self getBalanceServerRequestPath:oms_dir_log_service_server_get isHTTPS:SecureHttpRequired];
    [OMSHttpRequestAPI GET:requestPath parameters:nil Headers:nil completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSNumber *code = nil;
        NSString *msg = nil;
        NSMutableArray *results = [NSMutableArray array];
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        code = [responseDict valueForKey:@"code"];
        msg = [responseDict valueForKey:@"msg"];
        
        if (httpResponse.statusCode == 200 && responseObject) {
            results = [OMSResponseSerialization responseDataSerializationWith:[responseDict valueForKey:@"result"] modelClass:[OMSAccessItem class]];
        }
        if (completion) {
            completion(results, code.integerValue, msg);
        }
    }];
}

+ (void)checkSocketStatus {
    //当socket未连接成功时，线程等待。
    while (KOMSSocketApi.connectStatus != OMS_SOCKET_CONNECTED) {
        usleep(500000);
    }
}

- (void)backgroundHeartBeatResume {
    __block NSInteger cycleTime = 0;
    dispatch_queue_t timeQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _heartBeatTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, timeQueue);
    dispatch_source_set_timer(_heartBeatTimer, dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    OMS_WEAK_SELF
    dispatch_source_set_event_handler(_heartBeatTimer, ^{
        if (cycleTime % HEARTBEAT_TIME == 0) {
            OMSheartContent *content = [OMSheartContent contentWithTIN:kOMSDefaultConfigs.tin Uin:kOMSDefaultConfigs.uin];
            [OMSLogApi sendHear:content completion:^(NSError *error, id data) {
                if (!error) {
                    
                }
            }];
        }
        if (cycleTime % ((long)[KOMSSocketStack getSendInterval]) == 0) {
            dispatch_queue_t workQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(workQueue, ^{
                OMS_STRONG_SELF
                OMSLogD(@"======heartBeatTimer=====");
                [strongSelf startWork];
            });
        }
        cycleTime ++;
    });
    dispatch_resume(_heartBeatTimer);
}

- (void)backgroundHeartBeatStop {
    dispatch_source_cancel(_heartBeatTimer);
}

+ (NSString *)getBalanceServerRequestPath:(NSString *)dir isHTTPS:(BOOL)isHttps{
    if (isHttps) {
        return [self requestPathForHttpsWithServer:kOMSDefaultConfigs.balanceAddr port:kOMSDefaultConfigs.balanceHttpsPort dir:dir];
    }
    else{
        return [self requestPathForHttpWithServer:kOMSDefaultConfigs.balanceAddr port:kOMSDefaultConfigs.balanceHttpPort dir:dir];
    }
}

+ (NSString *)requestPathForHttpWithServer:(NSString *)server
                                      port:(NSString *)port
                                       dir:(NSString *)dir {
    NSString *requestPath;
    if (port.length > 0) {
        if ([server rangeOfString:@"http://"].length > 0) {
            server = [[server componentsSeparatedByString:@"http://"] lastObject];
        }
        if ([server rangeOfString:@"https://"].length > 0) {
            server = [[server componentsSeparatedByString:@"http://"] lastObject];
        }
        if ([server rangeOfString:@":"].length > 0) {
            server = [[server componentsSeparatedByString:@":"] firstObject];
        }
        requestPath = [NSString stringWithFormat:@"http://%@:%@%@", server, port, dir];
    }
    else {
        if ([server rangeOfString:@"http://"].length > 0) {
            server = [[server componentsSeparatedByString:@"http://"] lastObject];
        }
        if ([server rangeOfString:@"https://"].length > 0) {
            server = [[server componentsSeparatedByString:@"http://"] lastObject];
        }
        requestPath = [NSString stringWithFormat:@"http://%@%@", server, dir];
    }
    return requestPath;
}

+ (NSString *)requestPathForHttpsWithServer:(NSString *)server
                                       port:(NSString *)port
                                        dir:(NSString *)dir {
    NSString *requestPath;
    if (port.length > 0) {
        if ([server rangeOfString:@"http://"].length > 0) {
            server = [[server componentsSeparatedByString:@"http://"] lastObject];
        }
        if ([server rangeOfString:@"https://"].length > 0) {
            server = [[server componentsSeparatedByString:@"http://"] lastObject];
        }
        if ([server rangeOfString:@":"].length > 0) {
            server = [[server componentsSeparatedByString:@":"] firstObject];
        }
        requestPath = [NSString stringWithFormat:@"http://%@:%@%@", server, port, dir];
    }
    else {
        if ([server rangeOfString:@"http://"].length > 0) {
            server = [[server componentsSeparatedByString:@"http://"] lastObject];
        }
        if ([server rangeOfString:@"https://"].length > 0) {
            server = [[server componentsSeparatedByString:@"http://"] lastObject];
        }
        requestPath = [NSString stringWithFormat:@"https://%@%@", server, dir];
    }
    return requestPath;
}

@end
























