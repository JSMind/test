//
//  IVSDeviceCenter.h
//  IVSSDK
//
//  Created by 朱盛雄 on 17/1/18.
//  Copyright © 2017年 Sunniwell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMSDeviceCenter : NSObject

+ (NSString *)softwareVersion;

+ (NSString *)hardwareVersion;

+ (OMSNetworkMode)networkMode;

+ (NSString *)mac;

+ (NSString *)getUUID;
@end
