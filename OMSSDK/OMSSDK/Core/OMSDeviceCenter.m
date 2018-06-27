//
//  IVSDeviceCenter.m
//  IVSSDK
//
//  Created by 朱盛雄 on 17/1/18.
//  Copyright © 2017年 Sunniwell. All rights reserved.
//

#import "OMSDeviceCenter.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>
#import "OMSKeyChainStore.h"

#define kOMSDeviceCenter [OMSDeviceCenter defaultCenter]

@interface OMSDeviceCenter ()

@property (nonatomic, strong)NSString *macAddr;

@property (nonatomic, strong)NSString *hardwareVersion;

@property (nonatomic, strong)NSString *softwareVersion;

@end

@implementation OMSDeviceCenter

+ (OMSDeviceCenter *)defaultCenter {
    static OMSDeviceCenter *center;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[OMSDeviceCenter alloc] init];
    });
    return center;
}

+ (NSString *)softwareVersion {
    if (!kOMSDeviceCenter.softwareVersion) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        kOMSDeviceCenter.softwareVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    }
    return kOMSDeviceCenter.softwareVersion;
}

+ (NSString *)hardwareVersion {
    if (!kOMSDeviceCenter.hardwareVersion) {
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        
        NSArray *modelArray = @[
                                @"i386",
                                
                                @"x86_64",
                                
                                @"iPhone1,1",
                                @"iPhone1,2",
                                @"iPhone2,1",
                                @"iPhone3,1",
                                @"iPhone3,2",
                                @"iPhone3,3",
                                @"iPhone4,1",
                                @"iPhone5,1",
                                @"iPhone5,2",
                                @"iPhone5,3",
                                @"iPhone5,4",
                                @"iPhone6,1",
                                @"iPhone6,2",
                                @"iPhone7,2",
                                @"iPhone7,1",
                                
                                @"iPod1,1",
                                @"iPod2,1",
                                @"iPod3,1",
                                @"iPod4,1",
                                @"iPod5,1",
                                
                                @"iPad1,1",
                                @"iPad2,1",
                                @"iPad2,2",
                                @"iPad2,3",
                                @"iPad2,4",
                                @"iPad3,1",
                                @"iPad3,2",
                                @"iPad3,3",
                                @"iPad3,4",
                                @"iPad3,5",
                                @"iPad3,6",
                                
                                @"iPad2,5",
                                @"iPad2,6",
                                @"iPad2,7",
                                ];
        NSArray *modelNameArray = @[
                                    
                                    @"iPhone Simulator", @"iPhone Simulator",
                                    
                                    @"iPhone 2G",
                                    @"iPhone 3G",
                                    @"iPhone 3GS",
                                    @"iPhone 4(GSM)",
                                    @"iPhone 4(GSM Rev A)",
                                    @"iPhone 4(CDMA)",
                                    @"iPhone 4S",
                                    @"iPhone 5(GSM)",
                                    @"iPhone 5(GSM+CDMA)",
                                    @"iPhone 5c(GSM)",
                                    @"iPhone 5c(Global)",
                                    @"iphone 5s(GSM)",
                                    @"iphone 5s(Global)",
                                    @"iPhone 6(Global)",
                                    @"iPhone 6p(Global)",
                                    
                                    @"iPod Touch 1G",
                                    @"iPod Touch 2G",
                                    @"iPod Touch 3G",
                                    @"iPod Touch 4G",
                                    @"iPod Touch 5G",
                                    
                                    @"iPad",
                                    @"iPad 2(WiFi)",
                                    @"iPad 2(GSM)",
                                    @"iPad 2(CDMA)",
                                    @"iPad 2(WiFi + New Chip)",
                                    @"iPad 3(WiFi)",
                                    @"iPad 3(GSM+CDMA)",
                                    @"iPad 3(GSM)",
                                    @"iPad 4(WiFi)",
                                    @"iPad 4(GSM)",
                                    @"iPad 4(GSM+CDMA)",
                                    
                                    @"iPad mini (WiFi)",
                                    @"iPad mini (GSM)",
                                    @"ipad mini (GSM+CDMA)"
                                    ];
        NSInteger modelIndex = - 1;
        NSString *modelNameString = deviceString;
        modelIndex = [modelArray indexOfObject:deviceString];
        if (modelIndex >= 0 && modelIndex < [modelNameArray count]) {
            modelNameString = [modelNameArray objectAtIndex:modelIndex];
        }
        
        kOMSDeviceCenter.hardwareVersion = [NSString stringWithFormat:@"%@ %@ %@",
                                            modelNameString,
                                            [[UIDevice currentDevice] systemName],
                                            [[UIDevice currentDevice] systemVersion]];
    }
    return kOMSDeviceCenter.hardwareVersion;
}

+ (OMSNetworkMode)networkMode {
    return [kOMSDeviceCenter getNetWorkStates];
}

+ (NSString *)mac {
    if (!kOMSDeviceCenter.macAddr) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yy:MM:dd:HH:mm:ss"];
        NSDate *nowDate = [NSDate date];
        kOMSDeviceCenter.macAddr = [dateFormatter stringFromDate:nowDate];
    }
    return kOMSDeviceCenter.macAddr;
}

- (OMSNetworkMode)getNetWorkStates {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    OMSNetworkMode state = OMS_NETWORKMODE_UNKNOWN                                               ;
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            switch (netType) {
                case 0:
                    state = OMS_NETWORKMODE_UNKNOWN;
                    break;
                case 1:
                    state = OMS_NETWORKMODE_WIFI_DHCP;
                    break;
                case 2:
                    state = OMS_NETWORKMODE_WIFI_DHCP;
                    break;
                case 3:
                    state = OMS_NETWORKMODE_WIFI_DHCP;
                    break;
                case 5:
                    state = OMS_NETWORKMODE_WIFI_DHCP;
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}

+ (NSString *)getUUID {
    NSString *strUUID = (NSString *)[OMSKeyChainStore load:OMSKeyChainStoreUUIDKey];
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID) {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
        [OMSKeyChainStore save:OMSKeyChainStoreUUIDKey data:strUUID];
    }
    return strUUID;
}
@end
