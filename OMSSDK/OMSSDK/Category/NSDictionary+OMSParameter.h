//
//  NSDictionary+Parameter.h
//  LSSDK
//
//  Created by 朱盛雄 on 1/11/17.
//  Copyright © 2017 Sunniwell. All rights reserved.
//

#define OMSParametersEndSignal @"OMS.create.parameters.end"


#import <Foundation/Foundation.h>

@interface NSDictionary (OMSParameter)

//用LSParametersEndSignal来停止参数读取（而不是用nil），否则会进入死循环
+ (NSDictionary *)requestParametersByKeysAndValues:(id)firstObject, ...;
+ (NSDictionary *)requestParametersByAppendingDictionary:(NSDictionary *)dictionary keysAndValues:(id)firstObject, ...;

@end
