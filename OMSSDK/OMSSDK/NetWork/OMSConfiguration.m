//
//  OMSConfiguration.m
//  OMSSDK
//
//  Created by OS_HJS on 08/03/17.
//  Copyright © 2017年 sunniwell. All rights reserved.
//

#import "OMSConfiguration.h"

@interface OMSConfiguration ()
@property (nonatomic, assign)NSInteger mAccessIndex;
@end

@implementation OMSConfiguration

+ (OMSConfiguration *)defaultConfigs {
    static OMSConfiguration *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[OMSConfiguration alloc] init];
    });
    return config;
}

- (NSString *)httpServer {
    return _httpServer;
}
- (NSString *)socketHost {
    if (self.accessList.count > _mAccessIndex) {
        _socketHost = self.accessList[_mAccessIndex].host;
    }
    return _socketHost;
}

- (NSString *)socketPort {
    if (self.accessList.count > _mAccessIndex) {
        if (SecureHttpRequired) {
            _socketPort = self.accessList[_mAccessIndex].privates_port.stringValue;
        }
        else{
           _socketPort = self.accessList[_mAccessIndex].private_port.stringValue;
        }
    }
    return _socketPort;
}

- (NSString *)bcsAddr{
    return _bcsAddr;
}

- (NSString *)balanceAddr{
    return _balanceAddr;
}

- (NSString *)accessAddr{
    if (self.accessList.count > _mAccessIndex) {
        _accessAddr = self.accessList[_mAccessIndex].host;
    }
    return _accessAddr;
}

- (NSString *)epgsAddr{
    return _epgsAddr;
}

- (NSString *)balanceHttpPort{
    return _balanceHttpPort;
}

- (NSString *)balanceHttpsPort{
    return _balanceHttpsPort;
}

- (BOOL)switchAccess{
    if (self.accessList && self.accessList.count > 1) {
        _mAccessIndex = (_mAccessIndex + 1) % (self.accessList.count);
        return YES;
    }
    return NO;
}

- (OMSAccessItem *)getAccessServer{
    OMSAccessItem *item = nil;
    if (self.accessList && self.accessList.count > _mAccessIndex) {
        item = self.accessList[_mAccessIndex];
    }
    return item;
}

- (NSTimeZone *)localTimeZone{
    return [NSTimeZone localTimeZone];
}

- (NSNumber *)getCurrentTime{
    return @((long long)[[NSDate date] timeIntervalSince1970]*1000);
}

@end






























