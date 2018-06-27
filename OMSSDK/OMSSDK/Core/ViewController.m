//
//  ViewController.m
//  OMSSDKDemo
//
//  Created by OS_HJS on 2017/8/2.
//  Copyright © 2017年 sunniwell. All rights reserved.
//

static NSString *KTIN = @"72A48D5B-41AA-4346-B95E-E9188232F2AC";
static NSString *UIN = @"MXCloud";

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    dispatch_source_t _heartBeatTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    OMSLoginContent *content = [OMSLoginContent contentWithTIN:123 Uin:234 terminal_type:OMS_TERMINAlTYPE_IOS_PHONE];
//    [OMSLogApi login:content completion:^(NSError *error, id data) {
//        if (error) {
//            NSLog(@"失败");
//        }
//        else{
//            NSLog(@"jsfkofk");
//        }
//    }];
    for (int i = 0;i < 11; i++) {
        OMSDeviceInfoContent *dInfo = [OMSDeviceInfoContent contentWithLogType:OMS_LOGTYPE_DEVICEINFO terminal_int:[KTIN integerValue] user_int:[UIN integerValue] terminal_type:OMS_TERMINAlTYPE_IOS_PHONE login_type:OMS_LOGIN_TYPE_SELFID user_id:@"12345678" terminal_id:@"54969m" sp:@"32" mac:nil lanip:@"122" wanip:@"1212" netmode:OMS_NETWORKMODE_WIFI_DHCP wifistrength:143 chip:@"00" systemVersion:@"82" hardVersion:@"10" softVersion:@"943" appVersion:@"949" totalMemoryMB:23 totalRomMB:32 usedRomMB:43 freeRomMB:54 logcmode:OMS_LOGCOLLECTIONMODE_NORMAL bcsServer:@"" logServer:@"22323" epgsServer:@"3" upsServer:@"6" epg:@"d" timeZone:32 start_utc:32 curren_utc:232];
        [OMSLogApi sendDeviceInfoSync:dInfo completion:^(NSError *error, id data) {
            if (error) {
                NSLog(@"失败");
            }
            else{
                NSLog(@"jsfkofk");
            }
        }];
    }

    OMSLoginContent *content = [OMSLoginContent contentWithTIN:[KTIN integerValue] Uin:[UIN integerValue] terminal_type:OMS_TERMINAlTYPE_IOS_PHONE];
    [OMSLogApi login:content completion:^(NSError *error, id data) {
        if (error) {
            NSLog(@"失败");
        }
        else{
            NSLog(@"jsfkofk");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
