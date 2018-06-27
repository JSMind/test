//
//  OMSHead.m
//  OMSSDK
//
//  Created by OS_HJS on 2017/8/9.
//  Copyright © 2017年 sunniwell. All rights reserved.
//

#import "OMSHead.h"

static NSInteger const KHeadLength = 16;

@implementation OMSHead

- (NSString *)description{
    return [NSString stringWithFormat:@"Head数据:据:mPackageLength=%d,mHeadLengh=%d,mVersion=%d,mCommand=%d,mSessionId=%d",self.mPackageLength, self.mHeadLengh, self.mVersion, self.mCommand, self.mSessionId];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _mPackageLength = 0;
        _mHeadLengh = 16;
        _mVersion = 1;
        
        _mCommand = 0;
        _mSessionId = 0;
    }
    return self;
}

- (NSData *)headDataFormat{
    
    Byte byte[KHeadLength];
    
    byte[0] = (self.mPackageLength >> 24) & 0xff;
    byte[1] = (self.mPackageLength >> 16) & 0xff;
    byte[2] = (self.mPackageLength >> 8) & 0xff;
    byte[3] = self.mPackageLength&0xff;
    
    byte[4] = (self.mHeadLengh >> 8) & 0xff;
    byte[5] = self.mHeadLengh & 0xff;
    
    byte[6] = (self.mVersion >> 8) & 0xff;
    byte[7] = self.mVersion & 0xff;
    
    byte[8] = (self.mCommand >> 24) & 0xff;
    byte[9] = (self.mCommand >> 16) & 0xff;
    byte[10] = (self.mCommand >> 8) & 0xff;
    byte[11] = self.mCommand & 0xff;
    
    byte[12] = (self.mSessionId >> 24) & 0xff;
    byte[13] = (self.mSessionId >> 16) & 0xff;
    byte[14] = (self.mSessionId >> 8) & 0xff;
    byte[15] = self.mSessionId & 0xff;

    NSData *headData = [NSData dataWithBytes:byte length:sizeof(byte)];
    OMSLogD(@"Head数据:mPackageLength=%d,mHeadLengh=%d,mVersion=%d,mCommand=%d,mSessionId=%d",self.mPackageLength, self.mHeadLengh, self.mVersion, self.mCommand, self.mSessionId);
    return headData;
}


@end











