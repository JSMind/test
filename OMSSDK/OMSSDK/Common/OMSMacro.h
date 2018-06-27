//
//  OMSMacro.h
//  OMSSDK
//
//  Created by OS_HJS on 2017/8/2.
//  Copyright © 2017年 sunniwell. All rights reserved.
//

#ifndef OMSMacro_h
#define OMSMacro_h

#define OMS_WEAK_SELF __weak typeof(self)weakSelf = self;
#define OMS_STRONG_SELF __strong typeof(weakSelf)strongSelf = weakSelf;

#define OMSKeyChainStoreUUIDKey @"com.sunniwell.oms.keychainstore.key"

#pragma mark - 日志宏
/********************************
 *  日志宏：
 *    等级设置
 *    OMSLogLevel = 0,  //Verbose
 *    OMSLogLevel = 1,  //Debug
 *    OMSLogLevel = 2,  //Info
 *    OMSLogLevel = 3,  //Warning
 *    OMSLogLevel = 4,  //Error
 *    OMSLogLevel = 5,  //Close All
 ********************************/
#if DEBUG == 1

#define OMSLogV(fmt, ...) [CATLog logV:[NSString stringWithFormat:@"[%@:%d] %s %@",[NSString stringWithFormat:@"%s",__FILE__].lastPathComponent,__LINE__,__func__,fmt],##__VA_ARGS__,@""];
#define OMSLogD(fmt, ...) [CATLog logD:[NSString stringWithFormat:@"[%@:%d] %s %@",[NSString stringWithFormat:@"%s",__FILE__].lastPathComponent,__LINE__,__func__,fmt],##__VA_ARGS__,@""];
#define OMSLogI(fmt, ...) [CATLog logI:[NSString stringWithFormat:@"[%@:%d] %s %@",[NSString stringWithFormat:@"%s",__FILE__].lastPathComponent,__LINE__,__func__,fmt],##__VA_ARGS__,@""];
#define OMSLogW(fmt, ...) [CATLog logW:[NSString stringWithFormat:@"[%@:%d] %s %@",[NSString stringWithFormat:@"%s",__FILE__].lastPathComponent,__LINE__,__func__,fmt],##__VA_ARGS__,@""];
#define OMSLogE(fmt, ...) [CATLog logE:[NSString stringWithFormat:@"[%@:%d] %s %@",[NSString stringWithFormat:@"%s",__FILE__].lastPathComponent,__LINE__,__func__,fmt],##__VA_ARGS__,@""];

#else

#define OMSLogV(fmt, ...)
#define OMSLogD(fmt, ...)
#define OMSLogI(fmt, ...)
#define OMSLogW(fmt, ...)
#define OMSLogE(fmt, ...)

#endif


#endif /* OMSMacro_h */
