//
//  NSDictionary+Parameter.m
//  LSSDK
//
//  Created by 朱盛雄 on 1/11/17.
//  Copyright © 2017 Sunniwell. All rights reserved.
//

#import "NSDictionary+OMSParameter.h"

@implementation NSDictionary (OMSParameter)

+ (NSDictionary *)requestParametersByKeysAndValues:(id)firstObject, ... {
    NSMutableDictionary *mutableParams = [NSMutableDictionary dictionary];
    va_list arguments;
    id eachObject;
    if (firstObject) {
        va_start(arguments, firstObject);
        NSString *key = firstObject;
        for (NSInteger i = 0; ; i ++) {
            eachObject = va_arg(arguments, id);
            if ([eachObject isEqual:OMSParametersEndSignal]) {
                break;
            }
            if (i % 2 == 0) {
                if (eachObject && key) {
                    [mutableParams setValue:eachObject forKey:key];
                }
            }
            else {
                key = eachObject;
            }
        }
        va_end(arguments);
    }
    return [NSDictionary dictionaryWithDictionary:mutableParams];
}

+ (NSDictionary *)requestParametersByAppendingDictionary:(NSDictionary *)dictionary keysAndValues:(id)firstObject, ... {
    NSMutableDictionary *mutableParams = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    va_list arguments;
    id eachObject;
    if (firstObject) {
        va_start(arguments, firstObject);
        NSString *key = firstObject;
        for (NSInteger i = 0; ; i ++) {
            eachObject = va_arg(arguments, id);
            if ([eachObject isEqual:OMSParametersEndSignal]) {
                break;
            }
            if (i % 2 == 0) {
                if (eachObject && key) {
                    [mutableParams setValue:eachObject forKey:key];
                }
            }
            else {
                key = eachObject;
            }
        }
        va_end(arguments);
    }
    return [NSDictionary dictionaryWithDictionary:mutableParams];
}

@end
