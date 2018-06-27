//
//  OMSConfiguration.h
//  OMSSDK
//
//  Created by OS_HJS on 08/03/17.
//  Copyright © 2017年 sunniwell. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SecureHttpRequired NO
#define TokenRequired NO

#define kOMSDefaultConfigs [OMSConfiguration defaultConfigs]

@class OMSAccessItem;

@interface OMSConfiguration : NSObject

@property (nonatomic, strong)NSString *token;

@property (nonatomic, strong)NSArray <OMSAccessItem *>* accessList;
@property (nonatomic, strong)NSString *httpServer;
@property (nonatomic, strong)NSString *socketHost;
@property (nonatomic, strong)NSString *socketPort;
@property (nonatomic, strong)NSString *epgsAddr;
@property (nonatomic, strong)NSString *balanceAddr;
@property (nonatomic, strong)NSString *epgTemplate;
@property (nonatomic, strong)NSString *bcsAddr;
@property (nonatomic, strong)NSString *accessAddr;

@property (nonatomic, strong)NSString *balanceHttpPort;
@property (nonatomic, assign)NSString *balanceHttpsPort;
@property (nonatomic, strong)NSTimeZone *localTimeZone;
@property (nonatomic, strong)NSNumber *uin;
@property (nonatomic, strong)NSNumber *tin;
@property (nonatomic, strong)NSString *wanip;

+ (OMSConfiguration *)defaultConfigs;

- (BOOL)switchAccess;
- (OMSAccessItem *)getAccessServer;
- (NSNumber *)getCurrentTime;

@end
