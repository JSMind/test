//
//  OMSMessage.m
//  OMSSDK
//
//  Created by OS_HJS on 2017/8/8.
//  Copyright © 2017年 sunniwell. All rights reserved.
//

#import "OMSMessage.h"
#import "OMSHead.h"

@interface OMSMessage ()<OMSModelCustomPropertyUtils>

@end

@implementation OMSMessage

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self modelInitWithCoder:aDecoder];
}

- (instancetype)initWithHead:(OMSHead *)head content:(OMSContent *)content{
    self = [super init];
    if (self) {
        self.mHead = head;
        self.mContent = content;
        [self.contentData appendData:content.dataFormat];
    }
    return self;
}

- (void)addContent:(OMSContent *)content{
    if (content) {
        [self.contentData appendData:content.dataFormat];
    }
}

- (NSMutableData *)contentData{
    if (!_contentData) {
        _contentData = [[NSMutableData alloc] init];
    }
    return _contentData;
}

- (NSData *)getDataBytes{
    NSMutableData *mutableData = [[NSMutableData alloc] init];
    if (self.mHead) {
        [mutableData appendData:self.mHead.headDataFormat];
    }
    if (self.contentData) {
        [mutableData appendData:self.contentData];
    }
    return [NSData dataWithData:mutableData];
}

@end

@implementation OMSLoginMessage

- (instancetype)initWithTIN:(NSNumber *__nonnull)tin uin:(NSNumber *__nonnull)uin terminalType:(OMSTerminalType)terminalType{
    self = [super init];
    if (self) {
        self.mContent = [OMSLoginContent contentWithTIN:tin Uin:uin terminal_type:terminalType];
        
    }
    return self;
}

@end

@implementation OMSHeartMessage

- (instancetype)initWithTIN:(NSNumber *__nonnull)tin uin:(NSNumber *__nonnull)uin{
    self = [super init];
    if (self) {
        self.mHead = [[OMSHead alloc] init];
        self.mHead.mCommand = 10001;
        self.mContent = [OMSheartContent contentWithTIN:tin Uin:uin];
    }
    return self;
}

@end

@implementation OMSLogMessage

- (instancetype)initWithLogContent:(OMSLogContent *)logContent{
    self = [super init];
    if (self) {
        self.mContent = logContent;
    }
    return self;
}

@end


























