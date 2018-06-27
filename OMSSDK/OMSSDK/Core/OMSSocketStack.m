//
//  OMSSocketStack.m
//  OMSSDK
//
//  Created by OS_HJS on 2017/8/9.
//  Copyright © 2017年 sunniwell. All rights reserved.
//

#import "OMSSocketStack.h"

static long const KSendIntervalDefault = 5;         //5s发送一次
NSString * const OMSMessageStacKey = @"com.oms.messageStack";
static uint32_t _mSessionId = 1000;

@interface OMSSocketStack ()

@property (nonatomic, assign)OMSMessageSendType sendType;                   //发送类型
@property (nonatomic, strong)NSMutableDictionary *completionDic;            //回调
@property (nonatomic, strong)OMSMessage *currentMessage;
@property (nonatomic, assign)NSInteger currentCount;                        //消息数量
@property (nonatomic, assign)NSTimeInterval sendInterval;                   //延迟发送时间
@property (nonatomic, strong)NSLock *lock;

@end

@implementation OMSSocketStack

+ (instancetype)sharedInstance {
    static OMSSocketStack *socketStack = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socketStack = [[OMSSocketStack alloc] init];
    });
    return socketStack;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _sendInterval = KSendIntervalDefault;
        self.lock = [[NSLock alloc] init];
        self.lock.name = OMSMessageStacKey;
    }
    return self;
}

#pragma  mark - lazy loding
- (NSMutableArray<OMSMessage *> *)messageStack{
    if (!_messageStack) {
        _messageStack = @[].mutableCopy;
    }
    return _messageStack;
}

- (NSMutableDictionary *)completionDic{
    if (!_completionDic) {
        _completionDic = [NSMutableDictionary dictionary];
    }
    return _completionDic;
}

#pragma mark - public method

- (NSTimeInterval)getSendInterval{
    return _sendInterval;
}

- (void)setSendInterval:(NSTimeInterval)sendInterval{
    _sendInterval = sendInterval;
}

- (OMSSocketDidReadBlock)getCompletionForKey:(uint32_t)key{
    OMSSocketDidReadBlock completion = nil;
    completion = [self.completionDic valueForKey:@(key).stringValue];
    OMSLogD(@"OMSSocketStack getCompletionForKey completion:%@ key:%d", completion, key);
    return completion;
}

- (BOOL)setCompletionObj:(OMSSocketDidReadBlock)completion forKey:(uint32_t)key{
    if (completion) {
        [self.completionDic setObject:completion forKey:@(key).stringValue];
        OMSLogD(@"OMSSocketStack completionDic setObject %@ forkey %d", completion, key);
    }
    return YES;
}

- (void)removeCompletionForkey:(uint32_t)key{
   [self.completionDic removeObjectForKey:@(key).stringValue];
}

- (void)addCurrentContent:(OMSLogContent *)logContent{
    if (!_currentMessage) {
        _currentCount = 0;
        OMSHead *head = [[OMSHead alloc] init];
        head.mCommand = 10003;
        _currentMessage = [[OMSLogMessage alloc] initWithHead:head content:logContent];
    }
    else{
        [_currentMessage.contentData appendData:logContent.dataFormat];
    }
    _currentCount++;
    OMSLogD(@"OMSSocketStack currentCount= %d",_currentCount);
    if (_currentCount >= 10) {
        [self push:_currentMessage completion:nil];
        _currentMessage = nil;
    }
}

- (void)push:(OMSMessage *)message completion:(OMSSocketDidReadBlock)completion{
    if (message != nil) {
        [self.lock lock];
        _mSessionId++;
        message.mHead.mSessionId = _mSessionId;

        message.mHead.mPackageLength = ((uint32_t)[NSData dataWithData:message.contentData].length + message.mHead.mHeadLengh);
        [self.messageStack addObject:message];
        if (completion) {
          [self setCompletionObj:completion forKey:message.mHead.mSessionId];
        }
        [self.lock unlock];
    }
}

- (void)pushCurrentMessage{
    [self push:_currentMessage completion:nil];
    _currentMessage = nil;
}

- (OMSMessage *)pop{
    OMSMessage *message = nil;
    [self.lock lock];
    if (self.messageStack.count > 0) {
        message = [self.messageStack firstObject];
        OMSLogD(@"OMSSocketStack pop message");
    }
    [self.lock unlock];
    return message;
}

- (NSArray *)getStackMessageList{
    return [self.messageStack copy];
}

- (void)remove:(OMSMessage *)message{
    [self.lock lock];
    [self.messageStack removeObject:message];
    OMSLogD(@"OMSSocketStack remove message");
    [self.lock unlock];
}

- (void)removeAllMessage{
    [self.lock lock];
    [self.messageStack removeAllObjects];
    [self.lock unlock];
}

@end























