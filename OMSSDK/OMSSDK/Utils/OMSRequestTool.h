//
//  IVSRequestUtils.h
//  IVSSDK
//
//  Created by 朱盛雄 on 17/2/6.
//  Copyright © 2017年 Sunniwell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMSRequestTool : NSObject

+ (NSString *)requestPathForHttpWithServer:(NSString *)server
                                      port:(NSString *)port
                                       dir:(NSString *)dir;

+ (NSString *)requestPathForHttpsWithServer:(NSString *)server
                                       port:(NSString *)port
                                        dir:(NSString *)dir;

+ (NSString *)requestParametersFormChange:(NSDictionary *)parameters;

+ (NSDictionary *)requestAuthenHeaderByUIN:(NSString *)uin
                                      sign:(NSString *)sign
                                 timestamp:(NSString *)timestamp
                                    random:(NSString *)random
                                     token:(NSString *)token;

+ (BOOL)parametersAreNull:(id)firstObject, ...;

@end
