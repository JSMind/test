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

#pragma mark - 立即发送
- (IBAction)playStuck:(id)sender {
    [self omsLogReport:OMS_LOGTYPE_PLAYSTUCK];
}

- (IBAction)playError:(id)sender {
    [self omsLogReport:OMS_LOGTYPE_PLAYERROR];
}

- (IBAction)playStati:(id)sender {
    [self omsLogReport:OMS_LOGTYPE_PLAYSTATISTICS];
}

- (IBAction)epgError:(id)sender {
    [self omsLogReport:OMS_LOGTYPE_EPGERROR];
}

- (IBAction)deviceStatic:(id)sender {
    [self omsLogReport:OMS_LOGTYPE_DEVICESTATUS];
}

- (IBAction)deviceInfo:(id)sender {
    [self omsLogReport:OMS_LOGTYPE_DEVICEINFO];
}
- (IBAction)selfCheck:(id)sender {
    [self omsLogReport:OMS_LOGTYPE_SELFCHECK];
}

#pragma mark - 延迟发送
- (IBAction)sendPlayStuckSync:(id)sender {
    [self omsLogReportSync:OMS_LOGTYPE_PLAYSTUCK];
}

- (IBAction)sendPlayErrorSync:(id)sender {
    [self omsLogReportSync:OMS_LOGTYPE_PLAYERROR];
}

- (IBAction)sendPlayStatisSync:(id)sender {
    [self omsLogReportSync:OMS_LOGTYPE_PLAYSTATISTICS];
}

- (IBAction)sendDeviceStatusSync:(id)sender {
    [self omsLogReportSync:OMS_LOGTYPE_DEVICESTATUS];
}

- (IBAction)sendDeviceInfoSync:(id)sender {
    [self omsLogReportSync:OMS_LOGTYPE_DEVICEINFO];
}

- (IBAction)sendEPGErrorSync:(id)sender {
    [self omsLogReportSync:OMS_LOGTYPE_EPGERROR];
}

- (IBAction)sendSelfCheckSync:(id)sender {
    [self omsLogReportSync:OMS_LOGTYPE_SELFCHECK];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - OMS日志上报
- (void)omsLogReportSync:(OMSLogType)type{
    
    NSString *logDescStr =nil;
    switch (type) {
        case OMS_LOGTYPE_UNKNOWN:{
            
        }
            break;
        case OMS_LOGTYPE_DEVICEINFO:{
            //设备信息日志
            OMSDeviceInfoContent *deviceInfo = [OMSDeviceInfoContent contentWithLogType:OMS_LOGTYPE_DEVICEINFO terminal_int:@(10034) user_int:@(10085) terminal_type:OMS_TERMINAlTYPE_IOS_PHONE login_type:OMS_LOGIN_TYPE_PHONE user_id:@"1382" terminal_id:[OMSDeviceCenter getUUID] sp:nil mac:[OMSDeviceCenter mac] lanip:@"192.130.25" wanip:@"192.120.8" netmode:[OMSDeviceCenter networkMode] wifistrength:nil chip:nil systemVersion:nil hardVersion:[OMSDeviceCenter hardwareVersion] softVersion:[OMSDeviceCenter softwareVersion] appVersion:nil totalMemoryMB:nil totalRomMB:nil usedRomMB:nil freeRomMB:nil logcmode:OMS_LOGCOLLECTIONMODE_CLOSE bcsServer:@"191.433.12" logServer:kOMSDefaultConfigs.accessAddr epgsServer:@"129.535.43" upsServer:@"1234" epg:@"MX" timeZone:@([kOMSDefaultConfigs.localTimeZone.name integerValue]) start_utc:@(1000) curren_utc:kOMSDefaultConfigs.getCurrentTime];
            [OMSLogApi sendDeviceInfoSync:deviceInfo completion:nil];
            
            logDescStr = @"设备信息日志";
        }
            break;
        case OMS_LOGTYPE_DEVICESTATUS:{
            OMSDeviceStatusContent *content = [OMSDeviceStatusContent contentWithLogType:OMS_LOGTYPE_DEVICESTATUS terminal_int:@(10034) netmode:[OMSDeviceCenter networkMode] wifistrength:@(50) used_cpu:@(0) totalMemoryMB:@(2330) usedMemoryMB:@(10) freeMemoryMB:@(2320) totalRomMB:nil usedRomMB:nil freeRomMB:nil epgsPinInfo:nil cdnPinInfo:nil];
            [OMSLogApi sendODeviceStatusSync:content completion:nil];
            logDescStr = @"设备转态日志";
        }
            break;
        case OMS_LOGTYPE_PLAYSTATISTICS:{
            OMSPlayStatisticsLogContent *content = [OMSPlayStatisticsLogContent contentWithLogType:OMS_LOGTYPE_PLAYSTATISTICS terminal_int:@(10034) user_int:@(10085) terminal_id:[OMSDeviceCenter getUUID] user_id:@"138" terminal_type:OMS_TERMINAlTYPE_IOS_PHONE sp:@"" media_type:OMS_LOG_STATISTICS_VOD media_id:@"1224id" title:@"蜘蛛侠" url:@"http://play" epg:@"MX" path:@"" mediaCP:nil mediaSP:nil start_utc:kOMSDefaultConfigs.getCurrentTime end_utc:kOMSDefaultConfigs.getCurrentTime duration_watch:@(2322) first_time:@(212) stuck_count:@(23) download_bytes:@(32324)];
            [OMSLogApi sendPlayStatisticsSync:content completion:nil];
            
            logDescStr = @"播放统计日志";
        }
            break;
        case OMS_LOGTYPE_PLAYSTUCK:{
            OMSPlayStuckLogContent *content = [OMSPlayStuckLogContent contentWithLogType:OMS_LOGTYPE_PLAYSTUCK terminal_int:@(10034) user_int:@(10085) terminal_id:[OMSDeviceCenter getUUID] user_id:@"13828" terminal_type:OMS_TERMINAlTYPE_IOS_PHONE sp:@"haha" media_type:OMS_LOG_STATISTICS_VOD media_id:@"122id" title:@"蜘蛛侠" url:@"http://play" epg:@"MX" path:@"hhk" mediaCP:nil mediaSP:nil start_utc:nil first_time:nil stuck_utc:kOMSDefaultConfigs.getCurrentTime stuck_code:nil stuck_reason:nil cdn_server:nil];
            [OMSLogApi sendPlayStuckSync:content completion:^(NSError *error, id data) {
                if (!error) {
                    NSLog(@"dsjj");
                }
            }];
            
            logDescStr = @"播放卡顿日志";
        }
            break;
        case OMS_LOGTYPE_PLAYERROR:{
            OMSPlayErrorLogContent *content = [OMSPlayErrorLogContent contentWithLogType:OMS_LOGTYPE_PLAYERROR terminal_int:@(10034) user_int:@(10085) terminal_id:[OMSDeviceCenter getUUID] user_id:@"13828" terminal_type:OMS_TERMINAlTYPE_IOS_PHONE sp:nil media_type:OMS_LOG_STATISTICS_VOD media_id:@"18id" title:@"蜘蛛侠" url:@"http://play/url" epg:@"MX" path:@"" mediaCP:nil mediaSP:nil error_utc:kOMSDefaultConfigs.getCurrentTime error_code:nil error_reason:nil];
            [OMSLogApi sendPlayErrorSync:content completion:nil];
            
            logDescStr = @"播放出错日志";
        }
            break;
        case OMS_LOGTYPE_EPGERROR:{
            OMSEpgErrorLogContent *content = [OMSEpgErrorLogContent contentWithLogType:OMS_LOGTYPE_EPGERROR terminal_int:@(10034) user_int:@(10085) terminal_id:[OMSDeviceCenter getUUID] user_id:@"13828" terminal_type:OMS_TERMINAlTYPE_IOS_PHONE sp:nil epgsServer:@"huang" epg:@"MX" uri:@"" error_utc:kOMSDefaultConfigs.getCurrentTime error_code:nil error_reason:nil];
            [OMSLogApi sendEpgErrorSync:content completion:nil];
            
            logDescStr = @"EPG出错日志";
        }
            break;
        case OMS_LOGTYPE_SELFCHECK:{
            OMSSelfCheckLogContent *content = [OMSSelfCheckLogContent contentWithLogType:OMS_LOGTYPE_SELFCHECK terminal_int:@(10034) user_int:@(10085) terminal_id:[OMSDeviceCenter getUUID] user_id:@"13828" sp:nil bcsServer:@"192.11.23" bcsStatus:OMS_BCSSTATUS_TYPE_OK epgsServer:@"118.190.2" epg:@"MX" epgsStatus:OMS_EPGSSTATUS_TYPE_OK upsServer:@"abc" upsStatus:OMS_UPSSTATUS_TYPE_EXCEPTION playURL:@"http://play/url" bandWidth:@(22) start_utc:@(123) end_utc:kOMSDefaultConfigs.getCurrentTime];
            [OMSLogApi sendSelfCheckSync:content completion:nil];
            logDescStr = @"自检日志";
        }
            break;
        default:
            break;
    }
    OMSLogD(@"======omsLogLogReport: OMSLogType=%@", logDescStr);
}

- (void)omsLogReport:(OMSLogType)type{
    
    NSString *logDescStr =nil;
    switch (type) {
        case OMS_LOGTYPE_UNKNOWN:{
            
        }
            break;
        case OMS_LOGTYPE_DEVICEINFO:{
            //设备信息日志
            OMSDeviceInfoContent *deviceInfo = [OMSDeviceInfoContent contentWithLogType:OMS_LOGTYPE_DEVICEINFO terminal_int:@(10034) user_int:@(10085) terminal_type:OMS_TERMINAlTYPE_IOS_PHONE login_type:OMS_LOGIN_TYPE_PHONE user_id:@"1382" terminal_id:[OMSDeviceCenter getUUID] sp:nil mac:[OMSDeviceCenter mac] lanip:@"192.130.25" wanip:@"192.120.8" netmode:[OMSDeviceCenter networkMode] wifistrength:nil chip:nil systemVersion:nil hardVersion:[OMSDeviceCenter hardwareVersion] softVersion:[OMSDeviceCenter softwareVersion] appVersion:nil totalMemoryMB:nil totalRomMB:nil usedRomMB:nil freeRomMB:nil logcmode:OMS_LOGCOLLECTIONMODE_CLOSE bcsServer:@"191.433.12" logServer:kOMSDefaultConfigs.accessAddr epgsServer:@"129.535.43" upsServer:@"1234" epg:@"MX" timeZone:@([kOMSDefaultConfigs.localTimeZone.name integerValue]) start_utc:@(1000) curren_utc:kOMSDefaultConfigs.getCurrentTime];
            [OMSLogApi sendDeviceInfo:deviceInfo completion:nil];
            
            logDescStr = @"设备信息日志";
        }
            break;
        case OMS_LOGTYPE_DEVICESTATUS:{
            OMSDeviceStatusContent *content = [OMSDeviceStatusContent contentWithLogType:OMS_LOGTYPE_DEVICESTATUS terminal_int:@(10034) netmode:[OMSDeviceCenter networkMode] wifistrength:@(50) used_cpu:@(0) totalMemoryMB:@(2330) usedMemoryMB:@(10) freeMemoryMB:@(2320) totalRomMB:nil usedRomMB:nil freeRomMB:nil epgsPinInfo:nil cdnPinInfo:nil];
            [OMSLogApi sendDeviceStatus:content completion:nil];
            logDescStr = @"设备转态日志";
        }
            break;
        case OMS_LOGTYPE_PLAYSTATISTICS:{
            OMSPlayStatisticsLogContent *content = [OMSPlayStatisticsLogContent contentWithLogType:OMS_LOGTYPE_PLAYSTATISTICS terminal_int:@(10034) user_int:@(10085) terminal_id:[OMSDeviceCenter getUUID] user_id:@"138" terminal_type:OMS_TERMINAlTYPE_IOS_PHONE sp:@"" media_type:OMS_LOG_STATISTICS_VOD media_id:@"1224id" title:@"蜘蛛侠" url:@"http://play" epg:@"MX" path:@"" mediaCP:nil mediaSP:nil start_utc:kOMSDefaultConfigs.getCurrentTime end_utc:kOMSDefaultConfigs.getCurrentTime duration_watch:@(2322) first_time:@(212) stuck_count:@(23) download_bytes:@(32324)];
            [OMSLogApi sendPlayStatistics:content completion:nil];
            
            logDescStr = @"播放统计日志";
        }
            break;
        case OMS_LOGTYPE_PLAYSTUCK:{
            OMSPlayStuckLogContent *content = [OMSPlayStuckLogContent contentWithLogType:OMS_LOGTYPE_PLAYSTUCK terminal_int:@(10034) user_int:@(10085) terminal_id:[OMSDeviceCenter getUUID] user_id:@"13828" terminal_type:OMS_TERMINAlTYPE_IOS_PHONE sp:@"haha" media_type:OMS_LOG_STATISTICS_VOD media_id:@"122id" title:@"蜘蛛侠" url:@"http://play" epg:@"MX" path:@"hhk" mediaCP:nil mediaSP:nil start_utc:nil first_time:nil stuck_utc:kOMSDefaultConfigs.getCurrentTime stuck_code:nil stuck_reason:nil cdn_server:nil];
            [OMSLogApi sendPlayStuck:content completion:nil];
            
            logDescStr = @"播放卡顿日志";
        }
            break;
        case OMS_LOGTYPE_PLAYERROR:{
            OMSPlayErrorLogContent *content = [OMSPlayErrorLogContent contentWithLogType:OMS_LOGTYPE_PLAYERROR terminal_int:@(10034) user_int:@(10085) terminal_id:[OMSDeviceCenter getUUID] user_id:@"13828" terminal_type:OMS_TERMINAlTYPE_IOS_PHONE sp:nil media_type:OMS_LOG_STATISTICS_VOD media_id:@"18id" title:@"蜘蛛侠" url:@"http://play/url" epg:@"MX" path:@"" mediaCP:nil mediaSP:nil error_utc:kOMSDefaultConfigs.getCurrentTime error_code:nil error_reason:nil];
            [OMSLogApi sendPlayError:content completion:nil];
            
            logDescStr = @"播放出错日志";
        }
            break;
        case OMS_LOGTYPE_EPGERROR:{
            OMSEpgErrorLogContent *content = [OMSEpgErrorLogContent contentWithLogType:OMS_LOGTYPE_EPGERROR terminal_int:@(10034) user_int:@(10085) terminal_id:[OMSDeviceCenter getUUID] user_id:@"13828" terminal_type:OMS_TERMINAlTYPE_IOS_PHONE sp:nil epgsServer:@"huang" epg:@"MX" uri:@"" error_utc:kOMSDefaultConfigs.getCurrentTime error_code:nil error_reason:nil];
            [OMSLogApi sendEpgError:content completion:nil];
            
            logDescStr = @"EPG出错日志";
        }
            break;
        case OMS_LOGTYPE_SELFCHECK:{
            OMSSelfCheckLogContent *content = [OMSSelfCheckLogContent contentWithLogType:OMS_LOGTYPE_SELFCHECK terminal_int:@(10034) user_int:@(10085) terminal_id:[OMSDeviceCenter getUUID] user_id:@"13828" sp:nil bcsServer:@"192.11.23" bcsStatus:OMS_BCSSTATUS_TYPE_OK epgsServer:@"118.190.2" epg:@"MX" epgsStatus:OMS_EPGSSTATUS_TYPE_OK upsServer:@"abc" upsStatus:OMS_UPSSTATUS_TYPE_EXCEPTION playURL:@"http://play/url" bandWidth:@(22) start_utc:@(123) end_utc:kOMSDefaultConfigs.getCurrentTime];
            [OMSLogApi sendSelfCheck:content completion:nil];
            logDescStr = @"自检日志";
        }
            break;
        default:
            break;
    }
    OMSLogD(@"======omsLogLogReport: OMSLogType=%@", logDescStr);
}


@end
