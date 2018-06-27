//
//  NSData+Parameter.m
//  OMSSDK
//
//  Created by OS_HJS on 2017/8/8.
//  Copyright © 2017年 sunniwell. All rights reserved.
//

#import "NSData+OMSParameter.h"

@implementation NSData (OMSParameter)
+ (NSData *)appendParameters:(NSData *)firstObject, ...{
    NSMutableData *mutableParams = [[NSMutableData alloc] init];
    va_list arguments;
    NSData *eachObject;
    if (firstObject) {
        va_start(arguments, firstObject);
        [mutableParams appendData:firstObject];
        for (NSInteger i = 0; ; i ++) {
            eachObject = va_arg(arguments, NSData *);
            if ([eachObject isEqual:OMSParametersEndSignal.dataFormat]) {
                break;
            }
            else{
                [mutableParams appendData:eachObject];
            }
        }
        va_end(arguments);
    }
    return [NSData dataWithData:mutableParams];
}

@end
