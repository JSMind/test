//
//  OMSContent.m
//  OMSSDK
//
//  Created by OS_HJS on 2017/8/8.
//  Copyright © 2017年 sunniwell. All rights reserved.
//

#define KSEPARATOR [[NSData alloc] initWithBytes:SEPARATOR length:sizeof(SEPARATOR)]
#define KEND [NSString stringWithFormat:@"\n"].dataFormat
//#define LongToData(v) [NSString stringWithFormat:@"%ld",v].dataFormat
//#define IntToData(v) [NSString stringWithFormat:@"%d",v].dataFormat

#import "OMSContent.h"
static Byte SEPARATOR[] = {0x7F};
static NSString *const KOMSLogContentLogTypeKey = @"logtype";
static NSString *const KOMSLogContentTinKey = @"tin";
static NSString *const KOMSLogContentUinKey = @"uin";
static NSString *const kOMSLogContentTerminalIdKey = @"tid";
static NSString *const kOMSLogContentUserIdKey = @"uid";
static NSString *const KOMSLogContentLoginTypeKey = @"logintype";
static NSString *const KOMSLogContentTerminalTypeKey = @"ttype";
static NSString *const KOMSLogContentSPKey = @"sp";
static NSString *const KOMSLogContentMacKey = @"mac";
static NSString *const KOMSLogContentLanipKey = @"lanip";
static NSString *const KOMSLogContentWanipKey = @"wanip";
static NSString *const KOMSLogContentNetModeKey = @"netmode";
static NSString *const KOMSLogContentWifiStrengthKey = @"wifistrength";
static NSString *const KOMSLogContentChipKey = @"chip";
static NSString *const KOMSLogContentSystemVersionKey = @"osver";
static NSString *const KOMSLogContentHardVersionKey = @"hardver";
static NSString *const KOMSLogContentSoftVersionKey = @"softver";
static NSString *const KOMSLogContentAppVersionKey = @"appver";
static NSString *const KOMSLogContentTotoalMemoryKey = @"totolmem";
static NSString *const KOMSLogContentTotalRomKey = @"totalrom";
static NSString *const KOMSLogContentUsedRomKey = @"usedrom";
static NSString *const KOMSLogContentFreeRomKey = @"freerom";
static NSString *const KOMSLogContentLogcmodeKey = @"logcmode";
static NSString *const KOMSLogContentBCSServerKey = @"bcs";
static NSString *const KOMSLogContentLogServerKey = @"logs";
static NSString *const KOMSLogContentEpgsServerKey = @"epgs";
static NSString *const KOMSLogContentUpsServerKey = @"ups";
static NSString *const KOMSLogContentEpgKey = @"epg";
static NSString *const KOMSLogContentTimeZoneKey = @"timezone";
static NSString *const KOMSLogContentStartUtcKey = @"startutc";
static NSString *const KOMSLogContentCurUtcKey = @"curutc";
static NSString *const KOMSLogContentUsedCpuKey = @"usedcpu";
static NSString *const KOMSLogContentUsedMemoryKey = @"usedmem";
static NSString *const KOMSLogContentFreeMemoryKey = @"freemem";
static NSString *const KOMSLogContentEpgsPingInfoKey = @"epgspinginfo";
static NSString *const KOMSLogContentCdnPingInfoKey = @"cdnpinginfo";
static NSString *const KOMSLogContentEndUtcKey = @"endutc";
static NSString *const KOMSLogContentDurationKey = @"duration";
static NSString *const KOMSLogContentStuckCountKey = @"bfcount";
static NSString *const KOMSLogContentDownloadBytesKey = @"downbytes";
static NSString *const KOMSLogContentMediaTypeKey = @"mediatype";
static NSString *const KOMSLogContentMediaIdKey = @"mediaid";
static NSString *const KOMSLogContentMediaCPKey = @"mediacp";
static NSString *const KOMSLogContentMediaSPKey = @"mediasp";
static NSString *const KOMSLogContentStuckUtcKey = @"bfutc";
static NSString *const KOMSLogContentStuckReasonKey = @"bfreazon";
static NSString *const KOMSLogContentStuckCodeKey = @"bfcode";
static NSString *const KOMSLogContentErrorUtcKey = @"errutc";
static NSString *const KOMSLogContentErrorCodeKey = @"errcode";
static NSString *const KOMSLogContentErrorReasonKey = @"errreazon";
static NSString *const KOMSLogContentBcsStatusKey = @"bcsstatus";
static NSString *const KOMSLogContentEpgsStatusKey = @"epgsstatus";
static NSString *const KOMSLogContentUpsStatusKey = @"upsstatus";
static NSString *const KOMSLogContentPlayUrlKey = @"playurl";
static NSString *const KOMSLogContentBandWidthKey = @"bandwidth";
static NSString *const KOMSLogContentCdnStatusKey = @"cdsstatus";
static NSString *const KOMSLogContentUriKey = @"uri";
static NSString *const KOMSLogContentTitleKey = @"title";
static NSString *const KOMSLogContentUrlKey = @"url";
static NSString *const KOMSLogContentPathKey = @"path";
static NSString *const KOMSLogContentFirstTimeKey = @"fstime";
static NSString *const KOMSLogContentCdnServerKey = @"cds";

@interface OMSContent ()<OMSModelCustomPropertyUtils>

@end

@implementation OMSContent

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self modelInitWithCoder:aDecoder];
}

- (NSData *)dataFormat{
    return nil;
}

- (NSString *)longToString:(long)longNumber{
    return ([NSString stringWithFormat:@"%ld",longNumber]);
}

- (NSString *)intToString:(int)intNumber{
    return ([NSString stringWithFormat:@"%d",intNumber]);
}

@end

@implementation OMSLoginContent

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self modelInitWithCoder:aDecoder];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"tin=%ld, uin=%ld, ttype=%d", self.tin.longValue, self.uin.longValue, self.terminal_type];
}

- (NSData *)dataFormat{

    NSData *content;
    content = [NSData appendParameters:
               self.tin.stringValue.dataFormat,KSEPARATOR,
               self.uin.stringValue.dataFormat,KSEPARATOR,
               @(self.terminal_type).stringValue.dataFormat,KEND,
               OMSParametersEndSignal.dataFormat];
    
    OMSLogD(@"=====Content Length:%d", [content length]);
    
    return content;
}

+ (OMSLoginContent *)contentWithTIN:(NSNumber *__nonnull)tin
                                Uin:(NSNumber *__nonnull)uin
                      terminal_type:(OMSTerminalType)terminal_type{
    OMSLoginContent *login = [[OMSLoginContent alloc] init];
    login.tin = tin;
    login.uin = uin;
    login.terminal_type = terminal_type;
    return login;
}

@end

@implementation OMSheartContent

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self modelInitWithCoder:aDecoder];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"tin=%ld, uin=%ld", self.tin.longValue, self.uin.longValue];
}

- (NSData *)dataFormat{
    
    NSData *content;
    content = [NSData appendParameters:
               self.tin.stringValue.dataFormat,KSEPARATOR,
               self.uin.stringValue.dataFormat,KEND,
               OMSParametersEndSignal.dataFormat];
    
    OMSLogD(@"=====Content Length:%d", [content length]);
    
    return content;
}

+ (OMSheartContent *)contentWithTIN:(NSNumber *__nonnull)tin
                                Uin:(NSNumber *__nonnull)uin{
    OMSheartContent *heart = [[OMSheartContent alloc] init];
    heart.tin = tin;
    heart.uin = uin;
    return heart;
}

@end

@implementation OMSLogContent

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self modelInitWithCoder:aDecoder];
}

@end

@implementation OMSDeviceInfoContent

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self modelInitWithCoder:aDecoder];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"tin=%ld, uin=%ld", self.tin.longValue, self.uin.longValue];
}

- (NSData *)dataFormat{

    NSData *content;
    content = [NSData appendParameters:
               @(self.logType).stringValue.dataFormat,KSEPARATOR,
               self.tin.stringValue.dataFormat,KSEPARATOR,
               self.uin.stringValue.dataFormat,KSEPARATOR,
               @(self.terminal_type).stringValue.dataFormat,KSEPARATOR,
               @(self.login_type).stringValue.dataFormat,KSEPARATOR,
               self.user_id.dataFormat,KSEPARATOR,
               self.terminal_id.dataFormat,KSEPARATOR,
               self.sp.dataFormat,KSEPARATOR,
               self.mac.dataFormat,KSEPARATOR,
               self.lanip.dataFormat,KSEPARATOR,
               self.wanip.dataFormat,KSEPARATOR,
               @(self.netmode).stringValue.dataFormat,KSEPARATOR,
               self.wifistrength.stringValue.dataFormat,KSEPARATOR,
               self.chip.dataFormat,KSEPARATOR,
               self.systemVersion.dataFormat,KSEPARATOR,
               self.hardVersion.dataFormat,KSEPARATOR,
               self.softVersion.dataFormat,KSEPARATOR,
               self.appVersion.dataFormat,KSEPARATOR,
               self.totalMemoryMB.stringValue.dataFormat,KSEPARATOR,
               self.totalRomMB.stringValue.dataFormat,KSEPARATOR,
               self.usedRomMB.stringValue.dataFormat,KSEPARATOR,
               self.freeRomMB.stringValue.dataFormat,KSEPARATOR,
               @(self.logcmode).stringValue.dataFormat,KSEPARATOR,
               self.bcsServer.dataFormat,KSEPARATOR,
               self.logServer.dataFormat,KSEPARATOR,
               self.epgsServer.dataFormat,KSEPARATOR,
               self.upsServer.dataFormat,KSEPARATOR,
               self.epg.dataFormat,KSEPARATOR,
               self.timeZone.stringValue.dataFormat,KSEPARATOR,
               self.start_utc.stringValue.dataFormat,KSEPARATOR,
               self.curren_utc.stringValue.dataFormat,KEND,
               OMSParametersEndSignal.dataFormat];
    
    OMSLogD(@"=====Content Length:%d", [content length]);
    
    return content;
}

+ (OMSDeviceInfoContent *)contentWithLogType:(OMSLogType)logType
                                terminal_int:(NSNumber *__nonnull)terminal_int
                                    user_int:(NSNumber *__nonnull)user_int
                               terminal_type:(OMSTerminalType)terminal_type
                                  login_type:(OMSLoginType)login_type
                                     user_id:(NSString *__nonnull)user_id
                                 terminal_id:(NSString *__nonnull)terminal_id
                                          sp:(NSString *__nullable)sp
                                         mac:(NSString *__nonnull)mac
                                       lanip:(NSString *__nonnull)lanip
                                       wanip:(NSString *__nonnull)wanip
                                     netmode:(OMSNetworkMode)netmode
                                wifistrength:(NSNumber *__nullable)wifistrength
                                        chip:(NSString *__nullable)chip
                               systemVersion:(NSString *__nullable)systemVersion
                                 hardVersion:(NSString *__nullable)hardVersion
                                 softVersion:(NSString *__nullable)softVersion
                                  appVersion:(NSString *__nullable)appVersion
                               totalMemoryMB:(NSNumber *__nullable)totalMemoryMB
                                  totalRomMB:(NSNumber *__nullable)totalRomMB
                                   usedRomMB:(NSNumber *__nullable)usedRomMB
                                   freeRomMB:(NSNumber *__nullable)freeRomMB
                                    logcmode:(OMSLogCollectionMode)logcmode
                                   bcsServer:(NSString *__nonnull)bcsServer
                                   logServer:(NSString *__nonnull)logServer
                                  epgsServer:(NSString *__nonnull)epgsServer
                                   upsServer:(NSString *__nonnull)upsServer
                                         epg:(NSString *__nonnull)epg
                                    timeZone:(NSNumber *__nonnull)timeZone
                                   start_utc:(NSNumber *__nonnull)start_utc
                                  curren_utc:(NSNumber *__nonnull)curren_utc{
    OMSDeviceInfoContent *log = [[OMSDeviceInfoContent alloc] init];
    log.logType = logType;
    log.tin = terminal_int;
    log.uin = user_int;
    log.terminal_id = terminal_id;
    log.user_id = user_id;
    log.sp = sp;
    log.mac = mac;
    log.lanip = lanip;
    log.wanip = wanip;
    log.netmode = netmode;
    log.wifistrength = wifistrength;
    log.chip = chip;
    log.systemVersion = systemVersion;
    log.hardVersion = hardVersion;
    log.softVersion = softVersion;
    log.appVersion = appVersion;
    log.totalMemoryMB = totalMemoryMB;
    log.totalRomMB = totalRomMB;
    log.usedRomMB = usedRomMB;
    log.freeRomMB = freeRomMB;
    log.logcmode = logcmode;
    log.bcsServer = bcsServer;
    log.logServer = logServer;
    log.epgsServer = epgsServer;
    log.upsServer = upsServer;
    log.epg = epg;
    log.timeZone = timeZone;
    log.start_utc = start_utc;
    log.curren_utc = curren_utc;
    return log;
}

@end

@implementation OMSDeviceStatusContent

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self modelInitWithCoder:aDecoder];
}

- (NSData *)dataFormat{

    NSData *content;
    content = [NSData appendParameters:
               @(self.logType).stringValue.dataFormat,KSEPARATOR,
               self.tin.stringValue.dataFormat,KSEPARATOR,
               @(self.netmode).stringValue.dataFormat,KSEPARATOR,
               self.wifistrength.stringValue.dataFormat,KSEPARATOR,
               self.used_cpu.stringValue.dataFormat,KSEPARATOR,
               self.totalMemoryMB.stringValue.dataFormat,KSEPARATOR,
               self.usedMemoryMB.stringValue.dataFormat,KSEPARATOR,
               self.freeMemoryMB.stringValue.dataFormat,KSEPARATOR,
               self.totalRomMB.stringValue.dataFormat,KSEPARATOR,
               self.usedRomMB.stringValue.dataFormat,KSEPARATOR,
               self.freeRomMB.stringValue.dataFormat,KSEPARATOR,
               self.epgsPinInfo.dataFormat,KSEPARATOR,
               self.cdnPinInfo.dataFormat,KEND,
               OMSParametersEndSignal.dataFormat];
    
    OMSLogD(@"=====Content Length:%d", [content length]);
    
    return content;

}

+ (OMSDeviceStatusContent *)contentWithLogType:(OMSLogType)logType
                                  terminal_int:(NSNumber *__nonnull)terminal_int
                                       netmode:(OMSNetworkMode)netmode
                                  wifistrength:(NSNumber *__nonnull)wifistrength
                                      used_cpu:(NSNumber *__nonnull)used_cpu
                                 totalMemoryMB:(NSNumber *__nonnull)totalMemoryMB
                                  usedMemoryMB:(NSNumber *__nonnull)usedMemoryMB
                                  freeMemoryMB:(NSNumber *__nonnull)freeMemoryMB
                                    totalRomMB:(NSNumber *__nullable)totalRomMB
                                     usedRomMB:(NSNumber *__nullable)usedRomMB
                                     freeRomMB:(NSNumber *__nullable)freeRomMB
                                   epgsPinInfo:(NSString *__nullable)epgsPinInfo
                                    cdnPinInfo:(NSString *__nullable)cdnPinInfo{
    OMSDeviceStatusContent *log = [[OMSDeviceStatusContent alloc] init];
    log.logType = logType;
    log.tin = terminal_int;
    log.netmode = netmode;
    log.wifistrength = wifistrength;
    log.used_cpu = used_cpu;
    log.totalMemoryMB = totalMemoryMB;
    log.usedMemoryMB = usedMemoryMB;
    log.freeMemoryMB = freeMemoryMB;
    log.totalRomMB = totalRomMB;
    log.usedRomMB = usedRomMB;
    log.freeRomMB = freeRomMB;
    log.epgsPinInfo = epgsPinInfo;
    log.cdnPinInfo = cdnPinInfo;
    return log;
}

@end

@implementation OMSPlayStatisticsLogContent

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self modelInitWithCoder:aDecoder];
}

- (NSData *)dataFormat{
    
    NSData *content;
    content = [NSData appendParameters:
               @(self.logType).stringValue.dataFormat,KSEPARATOR,
               self.tin.stringValue.dataFormat,KSEPARATOR,
               self.uin.stringValue.dataFormat,KSEPARATOR,
               self.terminal_id.dataFormat,KSEPARATOR,
               self.user_id.dataFormat,KSEPARATOR,
               @(self.terminal_type).stringValue.dataFormat,KSEPARATOR,
               self.sp.dataFormat,KSEPARATOR,
               @(self.media_type).stringValue.dataFormat,KSEPARATOR,
               self.media_id.dataFormat,KSEPARATOR,
               self.title.dataFormat,KSEPARATOR,
               self.url.dataFormat,KSEPARATOR,
               self.epg.dataFormat,KSEPARATOR,
               self.path.dataFormat,KSEPARATOR,
               self.mediaCP.dataFormat,KSEPARATOR,
               self.mediaSP.dataFormat,KSEPARATOR,
               self.start_utc.stringValue.dataFormat,KSEPARATOR,
               self.end_utc.stringValue.dataFormat,KSEPARATOR,
               self.duration_watch.stringValue.dataFormat,KSEPARATOR,
               self.first_time.stringValue.dataFormat,KSEPARATOR,
               self.stuck_count.stringValue.dataFormat,KSEPARATOR,
               self.download_bytes.stringValue.dataFormat,KEND,
               OMSParametersEndSignal.dataFormat];
    
    OMSLogD(@"=====Content Length:%d", [content length]);
    return content;
}

+ (OMSPlayStatisticsLogContent *)contentWithLogType:(OMSLogType)logType
                                       terminal_int:(NSNumber *__nonnull)terminal_int
                                           user_int:(NSNumber *__nonnull)user_int
                                        terminal_id:(NSString *__nonnull)terminal_id
                                            user_id:(NSString *__nonnull)user_id
                                      terminal_type:(OMSTerminalType)terminal_type
                                                 sp:(NSString *__nullable)sp
                                         media_type:(OMSStatisticsLogMediaType)media_type
                                           media_id:(NSString *__nonnull)media_id
                                              title:(NSString *__nonnull)title
                                                url:(NSString *__nonnull)url
                                                epg:(NSString *__nonnull)epg
                                               path:(NSString *__nonnull)path
                                            mediaCP:(NSString *__nullable)mediaCP
                                            mediaSP:(NSString *__nullable)mediaSP
                                          start_utc:(NSNumber *__nonnull)start_utc
                                            end_utc:(NSNumber *__nonnull)end_utc
                                     duration_watch:(NSNumber *__nonnull)duration_watch
                                         first_time:(NSNumber *__nonnull)first_time
                                        stuck_count:(NSNumber *__nonnull)stuck_count
                                     download_bytes:(NSNumber *__nonnull)download_bytes{
    OMSPlayStatisticsLogContent *log = [[OMSPlayStatisticsLogContent alloc] init];
    log.logType = logType;
    log.tin = terminal_int;
    log.uin = user_int;
    log.terminal_id = terminal_id;
    log.user_id = user_id;
    log.terminal_type = terminal_type;
    log.sp = sp;
    log.media_type = media_type;
    log.media_id = media_id;
    log.title = title;
    log.url = url;
    log.epg = epg;
    log.path = path;
    log.mediaCP = mediaCP;
    log.mediaSP = mediaSP;
    log.start_utc = start_utc;
    log.end_utc = end_utc;
    log.duration_watch = duration_watch;
    log.first_time = first_time;
    log.stuck_count = stuck_count;
    log.download_bytes = download_bytes;
    return log;
}

@end

@implementation OMSPlayStuckLogContent

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self modelInitWithCoder:aDecoder];
}

- (NSData *)dataFormat{
    
    NSData *content;
    content = [NSData appendParameters:
               @(self.logType).stringValue.dataFormat,KSEPARATOR,
               self.tin.stringValue.dataFormat,KSEPARATOR,
               self.uin.stringValue.dataFormat,KSEPARATOR,
               self.terminal_id.dataFormat,KSEPARATOR,
               self.user_id.dataFormat,KSEPARATOR,
               @(self.terminal_type).stringValue.dataFormat,KSEPARATOR,
               self.sp.dataFormat,KSEPARATOR,
               @(self.media_type).stringValue.dataFormat,KSEPARATOR,
               self.media_id.dataFormat,KSEPARATOR,
               self.title.dataFormat,KSEPARATOR,
               self.url.dataFormat,KSEPARATOR,
               self.epg.dataFormat,KSEPARATOR,
               self.path.dataFormat,KSEPARATOR,
               self.mediaCP.dataFormat,KSEPARATOR,
               self.mediaSP.dataFormat,KSEPARATOR,
               self.start_utc.stringValue.dataFormat,KSEPARATOR,
               self.first_time.stringValue.dataFormat,KSEPARATOR,
               self.stuck_utc.stringValue.dataFormat,KSEPARATOR,
               self.stuck_code.stringValue.dataFormat,KSEPARATOR,
               self.stuck_reason.dataFormat,KSEPARATOR,
               self.cdn_server.dataFormat,KEND,
               OMSParametersEndSignal.dataFormat];
    
    OMSLogD(@"=====Content Length:%d", [content length]);
    
    return content;
}

+ (OMSPlayStuckLogContent *)contentWithLogType:(OMSLogType)logType
                                  terminal_int:(NSNumber *__nonnull)terminal_int
                                      user_int:(NSNumber *__nonnull)user_int
                                   terminal_id:(NSString *__nonnull)terminal_id
                                       user_id:(NSString *__nonnull)user_id
                                 terminal_type:(OMSTerminalType)terminal_type
                                            sp:(NSString *__nonnull)sp
                                    media_type:(OMSStatisticsLogMediaType)media_type
                                      media_id:(NSString *__nonnull)media_id
                                         title:(NSString *__nonnull)title
                                           url:(NSString *__nonnull)url
                                           epg:(NSString *__nonnull)epg
                                          path:(NSString *__nonnull)path
                                       mediaCP:(NSString *__nullable)mediaCP
                                       mediaSP:(NSString *__nullable)mediaSP
                                     start_utc:(NSNumber *__nullable)start_utc
                                    first_time:(NSNumber *__nullable)first_time
                                     stuck_utc:(NSNumber *__nonnull)stuck_utc
                                    stuck_code:(NSNumber *__nullable)stuck_code
                                  stuck_reason:(NSString *__nullable)stuck_reason
                                    cdn_server:(NSString *__nullable)cdn_server{
    OMSPlayStuckLogContent *log = [[OMSPlayStuckLogContent alloc] init];
    log.logType = logType;
    log.tin = terminal_int;
    log.uin = user_int;
    log.terminal_id = terminal_id;
    log.user_id = user_id;
    log.terminal_type = terminal_type;
    log.sp = sp;
    log.media_type = media_type;
    log.media_id = media_id;
    log.title = title;
    log.url = url;
    log.epg = epg;
    log.path = path;
    log.mediaCP = mediaCP;
    log.mediaSP = mediaSP;
    log.start_utc = start_utc;
    log.first_time = first_time;
    log.stuck_utc = stuck_utc;
    log.stuck_code = stuck_code;
    log.stuck_reason = stuck_reason;
    log.cdn_server = cdn_server;
    return log;
}

@end

@implementation OMSPlayErrorLogContent

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self modelInitWithCoder:aDecoder];
}

- (NSData *)dataFormat{
    
    NSData *content;
    content = [NSData appendParameters:
               @(self.logType).stringValue.dataFormat,KSEPARATOR,
               self.tin.stringValue.dataFormat,KSEPARATOR,
               self.uin.stringValue.dataFormat,KSEPARATOR,
               self.terminal_id.dataFormat,KSEPARATOR,
               self.user_id.dataFormat,KSEPARATOR,
               @(self.terminal_type).stringValue.dataFormat,KSEPARATOR,
               self.sp.dataFormat,KSEPARATOR,
               @(self.media_type).stringValue.dataFormat,KSEPARATOR,
               self.media_id.dataFormat,KSEPARATOR,
               self.title.dataFormat,KSEPARATOR,
               self.url.dataFormat,KSEPARATOR,
               self.epg.dataFormat,KSEPARATOR,
               self.path.dataFormat,KSEPARATOR,
               self.mediaCP.dataFormat,KSEPARATOR,
               self.mediaSP.dataFormat,KSEPARATOR,
               self.error_utc.stringValue.dataFormat,KSEPARATOR,
               self.error_code.stringValue.dataFormat,KSEPARATOR,
               self.error_reason.dataFormat,KEND,
               OMSParametersEndSignal.dataFormat];
    
    OMSLogD(@"=====Content Length:%d", [content length]);
    
    return content;
}

+ (OMSPlayErrorLogContent *)contentWithLogType:(OMSLogType)logType
                                  terminal_int:(NSNumber *__nonnull)terminal_int
                                      user_int:(NSNumber *__nonnull)user_int
                                   terminal_id:(NSString *__nonnull)terminal_id
                                       user_id:(NSString *__nonnull)user_id
                                 terminal_type:(OMSTerminalType)terminal_type
                                            sp:(NSString *__nullable)sp
                                    media_type:(OMSStatisticsLogMediaType)media_type
                                      media_id:(NSString *__nonnull)media_id
                                         title:(NSString *__nonnull)title
                                           url:(NSString *__nonnull)url
                                           epg:(NSString *__nonnull)epg
                                          path:(NSString *__nonnull)path
                                       mediaCP:(NSString *__nullable)mediaCP
                                       mediaSP:(NSString *__nullable)mediaSP
                                     error_utc:(NSNumber *__nonnull)error_utc
                                    error_code:(NSNumber *__nullable)error_code
                                  error_reason:(NSString *__nullable)error_reason{
    OMSPlayErrorLogContent *log = [[OMSPlayErrorLogContent alloc] init];
    log.logType = logType;
    log.tin = terminal_int;
    log.uin = user_int;
    log.terminal_id = terminal_id;
    log.user_id = user_id;
    log.terminal_type = terminal_type;
    log.sp = sp;
    log.media_type = media_type;
    log.media_id = media_id;
    log.title = title;
    log.url = url;
    log.epg = epg;
    log.path = path;
    log.mediaCP = mediaCP;
    log.mediaSP = mediaSP;
    log.error_utc = error_utc;
    log.error_code = error_code;
    log.error_reason = error_reason;
    return log;
}

@end

@implementation OMSEpgErrorLogContent

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self modelInitWithCoder:aDecoder];
}

- (NSData *)dataFormat{
    
    NSData *content;
    content = [NSData appendParameters:
               @(self.logType).stringValue.dataFormat,KSEPARATOR,
               self.tin.stringValue.dataFormat,KSEPARATOR,
               self.uin.stringValue.dataFormat,KSEPARATOR,
               self.terminal_id.dataFormat,KSEPARATOR,
               self.user_id.dataFormat,KSEPARATOR,
               @(self.terminal_type).stringValue.dataFormat,KSEPARATOR,
               self.sp.dataFormat,KSEPARATOR,
               self.epgsServer.dataFormat,KSEPARATOR,
               self.epg.dataFormat,KSEPARATOR,
               self.uri.dataFormat,KSEPARATOR,
               self.error_utc.stringValue.dataFormat,KSEPARATOR,
               self.error_code.stringValue.dataFormat,KSEPARATOR,
               self.error_reason.dataFormat,KEND,
               OMSParametersEndSignal.dataFormat];
    
    OMSLogD(@"=====Content Length:%d", [content length]);
    
    return content;
}

+ (OMSEpgErrorLogContent *)contentWithLogType:(OMSLogType)logType
                                 terminal_int:(NSNumber *__nonnull)terminal_int
                                     user_int:(NSNumber *__nonnull)user_int
                                  terminal_id:(NSString *__nonnull)terminal_id
                                      user_id:(NSString *__nonnull)user_id
                                terminal_type:(OMSTerminalType)terminal_type
                                           sp:(NSString *__nullable)sp
                                   epgsServer:(NSString *__nonnull)epgsServer
                                          epg:(NSString *__nonnull)epg
                                          uri:(NSString *__nonnull)uri
                                    error_utc:(NSNumber *__nonnull)error_utc
                                   error_code:(NSNumber *__nullable)error_code
                                 error_reason:(NSString *__nullable)error_reason{
    OMSEpgErrorLogContent *log = [[OMSEpgErrorLogContent alloc] init];
    log.logType = logType;
    log.tin = terminal_int;
    log.uin = user_int;
    log.terminal_id = terminal_id;
    log.user_id = user_id;
    log.terminal_type = terminal_type;
    log.sp = sp;
    log.epgsServer = epgsServer;
    log.epg = epg;
    log.uri = uri;
    log.error_utc = error_utc;
    log.error_code = error_code;
    log.error_reason = error_reason;
    return log;
}

@end

@implementation OMSSelfCheckLogContent

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self modelInitWithCoder:aDecoder];
}

- (NSData *)dataFormat{
    
    NSData *content;
    content = [NSData appendParameters:
               @(self.logType).stringValue.dataFormat,KSEPARATOR,
               self.tin.stringValue.dataFormat,KSEPARATOR,
               self.uin.stringValue.dataFormat,KSEPARATOR,
               self.terminal_id.dataFormat,KSEPARATOR,
               self.user_id.dataFormat,KSEPARATOR,
               self.sp.dataFormat,KSEPARATOR,
               self.bcsServer.dataFormat,KSEPARATOR,
               @(self.bcsStatus).stringValue.dataFormat,KSEPARATOR,
               self.epgsServer.dataFormat,KSEPARATOR,
               self.epg.dataFormat,KSEPARATOR,
               @(self.epgsStatus).stringValue.dataFormat,KSEPARATOR,
               self.upsServer.dataFormat,KSEPARATOR,
               @(self.upsStatus).stringValue.dataFormat,KSEPARATOR,
               self.playUrl.dataFormat,KSEPARATOR,
               self.bandWidth.stringValue.dataFormat,KSEPARATOR,
               self.start_utc.stringValue.dataFormat,KSEPARATOR,
               self.end_utc.stringValue.dataFormat,KEND,
               OMSParametersEndSignal.dataFormat];
    
    OMSLogD(@"=====Content Length:%d", [content length]);
    return content;
}

+ (OMSSelfCheckLogContent *)contentWithLogType:(OMSLogType)logType
                                  terminal_int:(NSNumber *__nonnull)terminal_int
                                      user_int:(NSNumber *__nonnull)user_int
                                   terminal_id:(NSString *__nonnull)terminal_id
                                       user_id:(NSString *__nonnull)user_id
                                            sp:(NSString *__nullable)sp
                                     bcsServer:(NSString *__nonnull)bcsServer
                                     bcsStatus:(OMSBCSStatusType)bcsStatus
                                    epgsServer:(NSString *__nonnull)epgsServer
                                           epg:(NSString *__nonnull)epg
                                    epgsStatus:(OMSEPGSStatusType)epgsStatus
                                     upsServer:(NSString *)upsServer
                                     upsStatus:(OMSUPSStatusType)upsStatus
                                       playURL:(NSString *__nonnull)playURL
                                     bandWidth:(NSNumber *__nonnull)bandWidth
                                     start_utc:(NSNumber *__nonnull)start_utc
                                       end_utc:(NSNumber *__nonnull)end_utc{
    OMSSelfCheckLogContent *log = [[OMSSelfCheckLogContent alloc] init];
    log.logType = logType;
    log.tin = terminal_int;
    log.uin = user_int;
    log.terminal_id = terminal_id;
    log.user_id = user_id;
    log.sp = sp;
    log.bcsServer = bcsServer;
    log.bcsStatus = bcsStatus;
    log.epgsServer = epgsServer;
    log.epg = epg;
    log.epgsStatus = epgsStatus;
    log.upsServer = upsServer;
    log.upsStatus = upsStatus;
    log.playUrl = playURL;
    log.bandWidth = bandWidth;
    log.start_utc = start_utc;
    log.end_utc = end_utc;
    return log;
}

@end

