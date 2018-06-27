//
//  OMSLogApi.h
//  OMSSDK
//
//  Created by OS_HJS on 2017/8/2.
//  Copyright © 2017年 sunniwell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMSContent.h"
#import "OMSDefine.h"

#define KOMSLogApi [OMSLogApi sharedInstance]

//typedef enum {
//    OMSLOGLEVEL_NONE = 0,       //不显示日志信息
//    OMSLOGLEVEL_ERROR = 1,      //显示错误以上信息
//    OMSLOGLEVEL_WARNING = 2,    //显示警告以上信息
//    OMSLOGLEVEL_DEBUG = 3       //显示所有日志信息
//}OMSLogLevel;

typedef void(^OMSListCompletion)(NSArray *list, NSInteger code, NSString *message);

/**
 延时发送无回调，completion传nil, 立即发送支持回调，completion可传
 */
@interface OMSLogApi : NSObject

+ (id)sharedInstance;

/**
 初始化OMS
 */
+ (void)InitWithBalanceServer:(NSString *)balanceServer
              balanceHttpPort:(NSString *)balanceHttpProt
             balanceHttpsPort:(NSString *)balanceHttpsPort;

/* ******************
 * 设置控制台日志输出级别      （与上报服务器日志无关）
 * @param level             日志等级，默认为NONE级别
 */
+ (void)setLogLevel:(OMSLogLevel)level;

///* ******************
// * 获取控制台日志输出级别      （与上报服务器日志无关）
// */
//+ (OMSLogLevel)currentLogLevel;

/** ************
 * 设置日志发送时间间隔
 * @param sendInterval      以秒为单位
 */
+ (void)setSendInterval:(NSTimeInterval)sendInterval;


/**
 * 获取日志发送时间间隔
 * @return 发送时间间隔
 */
+(NSTimeInterval)getSendInterval;

/** ************
 * 登录指令
 * @param loginContent      登录Content
 * @param complection       传nil处理
 */
+ (void)login:(OMSLoginContent *)loginContent
   completion:(OMSSocketDidReadBlock)complection;


/** ************
 * 心跳指令
 * @param heartContent      心跳Content
 * @param complection       传nil处理
 */
+ (void)sendHear:(OMSheartContent *)heartContent
      completion:(OMSSocketDidReadBlock)complection;

/** ************
 * 发送设备信息
 * @param deviceInfo        设备信息
 * @param complection       传nil处理
 */
+ (void)sendDeviceInfo:(OMSDeviceInfoContent *)deviceInfo
            completion:(OMSSocketDidReadBlock)complection;

/** ************
 * 立即发送设备信息
 * @param deviceInfo        设备信息
 * @param complection       传nil处理
 */
+ (void)sendDeviceInfoSync:(OMSDeviceInfoContent *)deviceInfo
                completion:(OMSSocketDidReadBlock)complection;

/** ************
 * 发送设备状态
 * @param deviceStatus      设备状态
 * @param complection       传nil处理
 */
+ (void)sendDeviceStatus:(OMSDeviceStatusContent *)deviceStatus
              completion:(OMSSocketDidReadBlock)complection;

/** ************
 * 立即发送设备状态
 * @param deviceStatus      设备状态
 * @param complection       传nil处理
 */
+ (void)sendODeviceStatusSync:(OMSDeviceStatusContent *)deviceStatus
                   completion:(OMSSocketDidReadBlock)complection;

/** ************
 * 发送播放统计
 * @param playStatistics    播放统计
 * @param complection       传nil处理
 */
+ (void)sendPlayStatistics:(OMSPlayStatisticsLogContent *)playStatistics
                completion:(OMSSocketDidReadBlock)complection;

/** ************
 * 立即发送播放统计
 * @param playStatistics    播放统计
 * @param complection       传nil处理
 */
+ (void)sendPlayStatisticsSync:(OMSPlayStatisticsLogContent *)playStatistics
                    completion:(OMSSocketDidReadBlock)complection;

/** ************
 * 发送播放卡顿
 * @param playStuck         播放卡顿
 * @param complection       传nil处理
 */
+ (void)sendPlayStuck:(OMSPlayStuckLogContent *)playStuck
           completion:(OMSSocketDidReadBlock)complection;

/** ************
 * 立即发送播放卡顿
 * @param playStuck         播放卡顿
 * @param complection       传nil处理
 */
+ (void)sendPlayStuckSync:(OMSPlayStuckLogContent *)playStuck
               completion:(OMSSocketDidReadBlock)complection;

/** ************
 * 发送播放出错
 * @param playError         播放出错
 * @param complection       传nil处理
 */
+ (void)sendPlayError:(OMSPlayErrorLogContent *)playError
           completion:(OMSSocketDidReadBlock)complection;

/** ************
 * 立即发送播放出错
 * @param playError         播放出错
 * @param complection       传nil处理
 */
+ (void)sendPlayErrorSync:(OMSPlayErrorLogContent *)playError
               completion:(OMSSocketDidReadBlock)complection;

/** ************
 * 发送EPG出错
 * @param epgError          EPG出错
 * @param complection       传nil处理
 */
+ (void)sendEpgError:(OMSEpgErrorLogContent *)epgError
          completion:(OMSSocketDidReadBlock)complection;

/** ************
 * 立即发送EPG出错
 * @param epgError          EPG出错
 * @param complection       传nil处理
 */
+ (void)sendEpgErrorSync:(OMSEpgErrorLogContent *)epgError
              completion:(OMSSocketDidReadBlock)complection;

/** ************
 * 发送自检信息
 * @param selfCheck         自检信息（机顶盒需要，手机端不需要）
 * @param complection       传nil处理
 */
+ (void)sendSelfCheck:(OMSSelfCheckLogContent *)selfCheck
           completion:(OMSSocketDidReadBlock)complection;

/** ************
 * 立即发送自检信息
 * @param selfCheck         自检信息（机顶盒需要，手机端不需要）
 * @param complection       传nil处理
 */
+ (void)sendSelfCheckSync:(OMSSelfCheckLogContent *)selfCheck
               completion:(OMSSocketDidReadBlock)complection;

/** ************
 * 设置服务器地址和端口号
 * @param server            服务器地址
 * @param port              端口号
 */
+ (void)setServer:(NSString *)server port:(NSString *)port;

/**
 建立长连接
 */
+ (void)connect;

/**
 断开连接
 */
+ (void)disconnect;

@end



























