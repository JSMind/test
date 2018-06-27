//
//  OMSContent.h
//  OMSSDK
//
//  Created by OS_HJS on 2017/8/8.
//  Copyright © 2017年 sunniwell. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum{
    OMS_LOGTYPE_UNKNOWN = 0,
    OMS_LOGTYPE_DEVICEINFO = 1,              //设备信息日志
    OMS_LOGTYPE_DEVICESTATUS=2,                //设备状态日志
    OMS_LOGTYPE_PLAYSTATISTICS=3,              //播放统计日志
    OMS_LOGTYPE_PLAYSTUCK=4,                   //播放卡顿日志
    OMS_LOGTYPE_PLAYERROR=5,                   //播放出错日志
    OMS_LOGTYPE_EPGERROR=6,                    //epg出错日志
    OMS_LOGTYPE_SELFCHECK=7                    //自检日志
}OMSLogType;

typedef enum{
    OMS_TERMINALTYPE_UNKOWN = 0,
    OMS_TERMINALTYPE_STB = 1,                //STB类型
    OMS_TERMINALTYPE_PC=2,                     //PC类型
    OMS_TERMINALTYPE_ANDROID_PHONE=3,          //Android手机类型
    OMS_TERMINALTYPE_ANDROID_PAD=4,            //Android pad
    OMS_TERMINAlTYPE_IOS_PHONE=5,              //苹果手机
    OMS_TERMINALTYPE_IOS_PAD=6,                //苹果pad
    OMS_TERMINALTYPE_WEB=7                     //网页
}OMSTerminalType;

typedef enum{
    OMS_LOGCOLLECTIONMODE_CLOSE = 0,         //关闭
    OMS_LOGCOLLECTIONMODE_NORMAL,            //正常采集
    OMS_LOGCOLLLECTIONMODE_DEBUG             //debug模式
}OMSLogCollectionMode;

typedef enum{
    OMS_NETWORKMODE_UNKNOWN = 0,             //unkown
    OMS_NETWORKMODE_LAN_DHCP,                //有线dhcp
    OMS_NETWORKMODE_LAN_STATIC,              //有线静态IP
    OMS_NETWORKMODE_LAN_PPPOE,               //有线PPPoE
    OMS_NETWORKMODE_WIFI_DHCP,               //wifi-dhcp
    OMS_NETWORKMODE_WIFI_STATIC,             //wifi-static
    OMS_NETWORKMODE_WIFI_PPPOE,              //wifi-pppoe
    OMS_NETWORKMODE_4G                       //4G网络
}OMSNetworkMode;

typedef enum {
    OMS_LOGIN_TYPE_UNKOWN = -1,
    OMS_LOGIN_TYPE_SELFID = 0,              //自定义id登录
    OMS_LOGIN_TYPE_PHONE,                   //手机号登录
    OMS_LOGIN_TYPE_EMAIL,                   //邮箱登录
    OMS_LOGIN_TYPE_QQ,                      //QQ授权登录
    OMS_LOGIN_TYPE_WECHAT,                  //微信授权登录
    OMS_LOGIN_TYPE_SINAWEIBO,               //新浪微博授权登录
    OMS_LOGIN_TYPE_PHONEVCODE               //手机号+验证码登陆(这种情况下密码passwd为验证码)
}OMSLoginType;

typedef enum{
    OMS_BCSSTATUS_TYPE_EXCEPTION=0,         //连接异常
    OMS_BCSSTATUS_TYPE_OK                   //连接OK
}OMSBCSStatusType;

typedef enum{
    OMS_EPGSSTATUS_TYPE_EXCEPTION=0,
    OMS_EPGSSTATUS_TYPE_OK
}OMSEPGSStatusType;

typedef enum{
    OMS_UPSSTATUS_TYPE_EXCEPTION=0,
    OMS_UPSSSTATUS_TYPE_OK
}OMSUPSStatusType;

typedef enum{
    OMS_CDSSTATUS_TYPE_EXCEPTION=0,
    OMS_CDSSTATUS_TYPE_OK
}OMSCDSStatusType;

typedef enum {
    OMS_LOG_STATISTICS_LIVE=1,
    OMS_LOG_STATISTICS_VOD,
    OMS_LOG_STATISTICS_PLAYBACK
}OMSStatisticsLogMediaType;

@interface OMSContent : NSObject

- (NSData *)dataFormat;

@end


@interface OMSLoginContent : OMSContent

@property (nonatomic, strong)NSNumber *tin;

@property (nonatomic, strong)NSNumber *uin;

@property (nonatomic, assign)OMSTerminalType terminal_type;

+ (OMSLoginContent *)contentWithTIN:(NSNumber *__nonnull)tin
                                Uin:(NSNumber *__nonnull)uin
                      terminal_type:(OMSTerminalType)terminal_type;


@end


@interface OMSheartContent : OMSContent

@property (nonatomic, strong)NSNumber *tin;

@property (nonatomic, strong)NSNumber *uin;

+ (OMSheartContent *)contentWithTIN:(NSNumber *__nonnull)tin
                                Uin:(NSNumber *__nonnull)uin;

@end


#pragma mark - log
@interface OMSLogContent : OMSContent

@property (nonatomic, assign)OMSLogType logType;

@end

@interface OMSDeviceInfoContent : OMSLogContent

@property (nonatomic, assign)NSNumber *tin;

@property (nonatomic, assign)NSNumber *uin;

@property (nonatomic, strong)NSString *user_id;

@property (nonatomic, strong)NSString *terminal_id;

@property (nonatomic, assign)OMSTerminalType terminal_type;

@property (nonatomic, assign)OMSLoginType login_type;

@property (nonatomic, strong)NSString *sp;

@property (nonatomic, strong)NSString *mac;

@property (nonatomic, strong)NSString *lanip;

@property (nonatomic, strong)NSString *wanip;

@property (nonatomic, assign)OMSNetworkMode netmode;

@property (nonatomic, strong)NSNumber *wifistrength;

@property (nonatomic, strong)NSString *chip;

@property (nonatomic, strong)NSString *systemVersion;

@property (nonatomic, strong)NSString *hardVersion;

@property (nonatomic, strong)NSString *softVersion;

@property (nonatomic, strong)NSString *appVersion;

@property (nonatomic, strong)NSNumber *totalMemoryMB;

@property (nonatomic, strong)NSNumber *totalRomMB;

@property (nonatomic, strong)NSNumber *usedRomMB;

@property (nonatomic, strong)NSNumber *freeRomMB;

@property (nonatomic, assign)OMSLogCollectionMode logcmode;

@property (nonatomic, strong)NSString *bcsServer;

@property (nonatomic, strong)NSString *logServer;

@property (nonatomic, strong)NSString *epgsServer;

@property (nonatomic, strong)NSString *upsServer;

@property (nonatomic, strong)NSString *epg;

@property (nonatomic, strong)NSNumber *timeZone;

@property (nonatomic, strong)NSNumber *start_utc;

@property (nonatomic, strong)NSNumber *curren_utc;


/***************
 * 设备信息日志
 * @param logType (must)         日志类型 取值1
 * @param terminal_int (must)    设备tin 终端唯一整数标识
 * @param user_int (must)        用户uin 用户唯一整数表示
 * @param terminal_type (must)   终端类型
 * @param login_type (must)      登陆类型
 * @param user_id (must)         用户id
 * @param terminal_id (must)     终端id串号
 * @param sp                     终端用户所属sp
 * @param mac (must)             mac地址
 * @param lanip (must)           内网IP IP地址，字符串格式
 * @param wanip (must)           公网IP IP地址，字符串格式
 * @param netmode (must)         网络连接类型
 * @param wifistrength           wifi信号强度 范围[0-100]，在使用wifi连接时有值
 * @param chip                   芯片类型
 * @param systemVersion          操作系统版本号
 * @param hardVersion            硬件版本号
 * @param softVersion            软件版本号
 * @param appVersion             app版本号
 * @param totalMemoryMB          内存大小 单位MB
 * @param totalRomMB             rom大小 单位MB
 * @param usedRomMB              已使用rom大小 单位MB
 * @param freeRomMB              剩余rom大小 单位MB
 * @param logcmode (must)        日志采集模式 0-关闭、1-正常采集、2-debug模式
 * @param bcsServer (must)       当前业务接入服务器地址 IP地址，字符串格式
 * @param logServer (must)       当前日志接入服务器地址
 * @param epgsServer (must)      当前epgs服务器地址
 * @param upsServer (must)       当前升级服务器
 * @param epg (must)             EPG模板
 * @param timeZone (must)        时区
 * @param start_utc (must)       开机时间 utc时间，单位ms
 * @param curren_utc (must)      当前时间 utc时间，单位ms
 */
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
                                  curren_utc:(NSNumber *__nonnull)curren_utc;

@end

@interface OMSDeviceStatusContent : OMSLogContent

@property (nonatomic, strong)NSNumber *tin;

@property (nonatomic, assign)OMSNetworkMode netmode;

@property (nonatomic, strong)NSNumber *wifistrength;

@property (nonatomic, strong)NSNumber *used_cpu;

@property (nonatomic, strong)NSNumber *totalMemoryMB;

@property (nonatomic, strong)NSNumber *usedMemoryMB;

@property (nonatomic, strong)NSNumber *freeMemoryMB;

@property (nonatomic, strong)NSNumber *totalRomMB;

@property (nonatomic, strong)NSNumber *usedRomMB;

@property (nonatomic, strong)NSNumber *freeRomMB;

@property (nonatomic, strong)NSString *epgsPinInfo;

@property (nonatomic, strong)NSString *cdnPinInfo;

/************
 * 设备状态日志
 * @param logType (must)        日志类型 取值2
 * @param terminal_int (must)   设备tin 终端唯一整数标识
 * @param netmode (must)        网络连接类型
 * @param wifistrength          wifi信号强度 范围[0-100]，在使用wifi连接时有值
 * @param used_cpu (must)       cpu使用率 百分比，范围[0-100]
 * @param totalMemoryMB (must)  内存大小 单位MB
 * @param usedMemoryMB (must)   已使用内存大小 单位MB
 * @param freeMemoryMB (must)   剩余内存大小  单位MB
 * @param totalRomMB            rom大小 单位MB
 * @param usedRomMB             已使用rom大小 单位MB
 * @param freeRomMB             剩余rom大小 单位MB
 * @param epgsPinInfo (must)    epgs服务器ping信息 字符串格式，可以考虑直接将linux的ping命令返回作为输入
 * @param cdnPinInfo (must)     cdn服务器ping信息 字符串格式，可以考虑直接将linux的ping命令返回作为输入
 */
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
                                    cdnPinInfo:(NSString *__nullable)cdnPinInfo;

@end

@interface OMSPlayStatisticsLogContent : OMSLogContent

@property (nonatomic, strong)NSNumber *tin;

@property (nonatomic, strong)NSNumber *uin;

@property (nonatomic, strong)NSString *terminal_id;

@property (nonatomic, strong)NSString *user_id;

@property (nonatomic, assign)OMSTerminalType terminal_type;

@property (nonatomic, strong)NSString *sp;

@property (nonatomic, assign)OMSStatisticsLogMediaType media_type;

@property (nonatomic, strong)NSString *media_id;

@property (nonatomic, strong)NSString *title;

@property (nonatomic, strong)NSString *url;

@property (nonatomic, strong)NSString *epg;

@property (nonatomic, strong)NSString *path;

@property (nonatomic, strong)NSString *mediaCP;

@property (nonatomic, strong)NSString *mediaSP;

@property (nonatomic, strong)NSNumber *start_utc;

@property (nonatomic, strong)NSNumber *end_utc;

@property (nonatomic, strong)NSNumber *duration_watch;

@property (nonatomic, strong)NSNumber *first_time;

@property (nonatomic, strong)NSNumber *stuck_count;

@property (nonatomic, strong)NSNumber *download_bytes;

/***************
 * 播放统计日志
 * @param logType (must)         日志类型 取值3
 * @param terminal_int (must)    设备tin 终端唯一整数标识
 * @param user_int (must)        用户uin 用户唯一整数表示
 * @param terminal_id (must)     终端id串号
 * @param user_id (must)         用户id
 * @param terminal_type (must)   终端类型
 * @param sp                     终端用户所属sp
 * @param media_type (must)      播放的媒资类型 1-直播、2-点播、3-回看
 * @param media_id (must)        播放的媒资id
 * @param title (must)           媒资title
 * @param url (must)             播放url
 * @param epg (must)             连接的epg模板
 * @param path (must)            媒资路径 栏目id层级路径，格式形如：1->100
 * @param mediaCP (must)         媒资cp
 * @param mediaSP (must)         媒资sp
 * @param start_utc (must)       开始播放时间 utc时间，单位ms
 * @param end_utc (must)         结束播放实际 utc时间，单位ms
 * @param duration_watch (must)  播放时长 单位s
 * @param first_time (must)      首屏时间 即开始请求播放到首帧画面出现所需要的时间，单位ms
 * @param stuck_count (must)     卡顿次数
 * @param download_bytes (must)  下载字节数 单位byte，可据此统计流量
 */
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
                                     download_bytes:(NSNumber *__nonnull)download_bytes;

@end

@interface OMSPlayStuckLogContent : OMSLogContent

@property (nonatomic, strong)NSNumber *tin;

@property (nonatomic, strong)NSNumber *uin;

@property (nonatomic, strong)NSString *terminal_id;

@property (nonatomic, strong)NSString *user_id;

@property (nonatomic, assign)OMSTerminalType terminal_type;

@property (nonatomic, strong)NSString *sp;

@property (nonatomic, assign)OMSStatisticsLogMediaType media_type;

@property (nonatomic, strong)NSString *media_id;

@property (nonatomic, strong)NSString *title;

@property (nonatomic, strong)NSString *url;

@property (nonatomic, strong)NSString *epg;

@property (nonatomic, strong)NSString *path;

@property (nonatomic, strong)NSString *mediaCP;

@property (nonatomic, strong)NSString *mediaSP;

@property (nonatomic, strong)NSNumber *start_utc;

@property (nonatomic, strong)NSNumber *first_time;

@property (nonatomic, strong)NSNumber *stuck_utc;

@property (nonatomic, strong)NSNumber *stuck_code;

@property (nonatomic, strong)NSString *stuck_reason;

@property (nonatomic, strong)NSString *cdn_server;

/***************
 * 播放卡顿日志
 * @param logType (must)         日志类型 取值4
 * @param terminal_int (must)    设备tin 终端唯一整数标识
 * @param user_int (must)        用户uin 用户唯一整数表示
 * @param terminal_id (must)     终端id串号
 * @param user_id (must)         用户id
 * @param terminal_type (must)   终端类型
 * @param sp (must)              终端用户所属sp
 * @param media_type (must)      播放的媒资类型 1-直播、2-点播、3-回看
 * @param media_id (must)        播放的媒资id
 * @param title (must)           媒资title
 * @param url (must)             播放url
 * @param epg (must)             连接的epg模板
 * @param path (must)            媒资路径 栏目id层级路径，格式形如：1->100
 * @param mediaCP                媒资cp
 * @param mediaSP                媒资sp
 * @param start_utc              开始播放时间 utc时间，单位ms
 * @param first_time             首屏时间 即开始请求播放到首帧画面出现所需要的时间，单位ms
 * @param stuck_utc (must)       卡顿发生时间
 * @param stuck_code             卡顿代码
 * @param stuck_reason           卡顿原因 原因描述，如网络异常、CDN获取不到流等
 * @param cdn_server             cdn服务器ip 实际给终端推流的cdn地址
 */
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
                                    cdn_server:(NSString *__nullable)cdn_server;

@end

@interface OMSPlayErrorLogContent : OMSLogContent

@property (nonatomic, strong)NSNumber *tin;

@property (nonatomic, strong)NSNumber *uin;

@property (nonatomic, strong)NSString *terminal_id;

@property (nonatomic, strong)NSString *user_id;

@property (nonatomic, assign)OMSTerminalType terminal_type;

@property (nonatomic, strong)NSString *sp;

@property (nonatomic, assign)OMSStatisticsLogMediaType media_type;

@property (nonatomic, strong)NSString *media_id;

@property (nonatomic, strong)NSString *title;

@property (nonatomic, strong)NSString *url;

@property (nonatomic, strong)NSString *epg;

@property (nonatomic, strong)NSString *path;

@property (nonatomic, strong)NSString *mediaCP;

@property (nonatomic, strong)NSString *mediaSP;

@property (nonatomic, assign)NSNumber *error_utc;

@property (nonatomic, assign)NSNumber *error_code;

@property (nonatomic, strong)NSString *error_reason;

/***************
 * 播放出错日志
 * @param logType (must)         日志类型 取值5
 * @param terminal_int (must)    设备tin 终端唯一整数标识
 * @param user_int (must)        用户uin 用户唯一整数表示
 * @param terminal_id (must)     终端id串号
 * @param user_id (must)         用户id
 * @param terminal_type (must)   终端类型
 * @param sp                     终端用户所属sp
 * @param media_type (must)      播放的媒资类型 1-直播、2-点播、3-回看
 * @param media_id (must)        播放的媒资id
 * @param title (must)           媒资title
 * @param url (must)             播放url
 * @param epg (must)             连接的epg模板
 * @param path (must)            媒资路径 栏目id层级路径，格式形如：1->100
 * @param mediaCP                媒资cp
 * @param mediaSP                媒资sp
 * @param error_utc (must)       出错时间 utc时间，单位ms
 * @param error_code             出错代码
 * @param error_reason           出错原因 出错原因描述，如网络异常、CDN获取不到流，甚或是播放器出错的相关打印
 */
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
                                  error_reason:(NSString *__nullable)error_reason;

@end

@interface OMSEpgErrorLogContent : OMSLogContent

@property (nonatomic, strong)NSNumber *tin;

@property (nonatomic, strong)NSNumber *uin;

@property (nonatomic, strong)NSString *terminal_id;

@property (nonatomic, strong)NSString *user_id;

@property (nonatomic, assign)OMSTerminalType terminal_type;

@property (nonatomic, strong)NSString *sp;

@property (nonatomic, strong)NSString *epgsServer;

@property (nonatomic, strong)NSString *epg;

@property (nonatomic, strong)NSString *uri;

@property (nonatomic, strong)NSNumber *error_utc;

@property (nonatomic, strong)NSNumber *error_code;

@property (nonatomic, strong)NSString *error_reason;

/***************
 * EPG出错日志
 * @param logType (must)         日志类型 取值6
 * @param terminal_int (must)    设备tin 终端唯一整数标识
 * @param user_int (must)        用户uin 用户唯一整数表示
 * @param terminal_id (must)     终端id串号
 * @param user_id (must)         用户id
 * @param terminal_type (must)   终端类型
 * @param sp                     终端用户所属sp
 * @param epgsServer (must)      epgs服务器
 * @param epg (must)             连接的epg模板
 * @param uri (must)             请求的uri 请求的哪个epgs接口uri
 * @param error_utc (must)       出错时间 utc时间，单位ms
 * @param error_code             出错代码
 * @param error_reason           出错原因 出错原因描述
 */
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
                                 error_reason:(NSString *__nullable)error_reason;

@end

@interface OMSSelfCheckLogContent : OMSLogContent

@property (nonatomic, strong)NSNumber *tin;

@property (nonatomic, strong)NSNumber *uin;

@property (nonatomic, strong)NSString *terminal_id;

@property (nonatomic, strong)NSString *user_id;

@property (nonatomic, strong)NSString *sp;

@property (nonatomic, strong)NSString *bcsServer;

@property (nonatomic, assign)OMSBCSStatusType bcsStatus;

@property (nonatomic, strong)NSString *epgsServer;

@property (nonatomic, strong)NSString *epg;

@property (nonatomic, assign)OMSEPGSStatusType epgsStatus;

@property (nonatomic, strong)NSString *upsServer;

@property (nonatomic, assign)OMSUPSStatusType upsStatus;

@property (nonatomic, strong)NSString *playUrl;

@property (nonatomic, strong)NSNumber *bandWidth;

@property (nonatomic, strong)NSNumber *start_utc;

@property (nonatomic, strong)NSNumber *end_utc;

/***************
 * 自检日志
 * @param logType (must)         日志类型 取值6
 * @param terminal_int (must)    设备tin 终端唯一整数标识
 * @param user_int (must)        用户uin 用户唯一整数表示
 * @param terminal_id (must)     终端id串号
 * @param user_id (must)         用户id
 * @param sp                     终端用户所属sp
 * @param bcsServer (must)       业务接入服务器 域名或者IP加端口，如sunniwell.net:8080
 * @param bcsStatus (must)       业务服务器连接状态 1-表示OK，0-表示连接异常
 * @param epgsServer (must)      epgs服务器 域名或者IP加端口，如sunniwell.net:8080
 * @param epg (must)             连接的epg模板
 * @param epgsStatus (must)      epgs服务器连接 1-表示OK，0-表示连接异常
 * @param upsServer (must)       升级服务器地址 域名或者IP加端口，如sunniwell.net:8080
 * @param upsStatus (must)       升级服务器连接状态 1-表示OK，0-表示连接异常
 * @param playURL (must)         测试播放url
 * @param bandWidth (must)       测速带宽 测速带宽结果，单位bps。计算方法：下载的测速ts的总字节数*8/下载时长
 * @param start_utc (must)       开始测试时间 utc时间，单位ms
 * @param end_utc   (must)       结束测试时间 utc时间，单位ms
 */
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
                                       end_utc:(NSNumber *__nonnull)end_utc;

@end

NS_ASSUME_NONNULL_END













