//
//  IVSRequestUtils.m
//  IVSSDK
//
//  Created by 朱盛雄 on 17/2/6.
//  Copyright © 2017年 Sunniwell. All rights reserved.
//

#import "OMSRequestTool.h"

@implementation OMSRequestTool

+ (NSString *)requestPathForHttpWithServer:(NSString *)server
                                      port:(NSString *)port
                                       dir:(NSString *)dir {
    NSString *requestPath;
    if (port.length > 0) {
        if ([server rangeOfString:@"http://"].length > 0) {
            server = [[server componentsSeparatedByString:@"http://"] lastObject];
        }
        if ([server rangeOfString:@"https://"].length > 0) {
            server = [[server componentsSeparatedByString:@"http://"] lastObject];
        }
        if ([server rangeOfString:@":"].length > 0) {
            server = [[server componentsSeparatedByString:@":"] firstObject];
        }
        requestPath = [NSString stringWithFormat:@"http://%@:%@%@", server, port, dir];
    }
    else {
        if ([server rangeOfString:@"http://"].length > 0) {
            server = [[server componentsSeparatedByString:@"http://"] lastObject];
        }
        if ([server rangeOfString:@"https://"].length > 0) {
            server = [[server componentsSeparatedByString:@"http://"] lastObject];
        }
        requestPath = [NSString stringWithFormat:@"http://%@%@", server, dir];
    }
    return requestPath;
}

+ (NSString *)requestPathForHttpsWithServer:(NSString *)server
                                       port:(NSString *)port
                                        dir:(NSString *)dir {
    NSString *requestPath;
    if (port.length > 0) {
        if ([server rangeOfString:@"http://"].length > 0) {
            server = [[server componentsSeparatedByString:@"http://"] lastObject];
        }
        if ([server rangeOfString:@"https://"].length > 0) {
            server = [[server componentsSeparatedByString:@"http://"] lastObject];
        }
        if ([server rangeOfString:@":"].length > 0) {
            server = [[server componentsSeparatedByString:@":"] firstObject];
        }
        requestPath = [NSString stringWithFormat:@"http://%@:%@%@", server, port, dir];
    }
    else {
        if ([server rangeOfString:@"http://"].length > 0) {
            server = [[server componentsSeparatedByString:@"http://"] lastObject];
        }
        if ([server rangeOfString:@"https://"].length > 0) {
            server = [[server componentsSeparatedByString:@"http://"] lastObject];
        }
        requestPath = [NSString stringWithFormat:@"https://%@%@", server, dir];
    }
    return requestPath;
}

+ (NSString *)requestParametersFormChange:(NSDictionary *)parameters {
    NSString *requestParametersString = nil;
    for (NSString *key in parameters.allKeys) {
        NSString *value = parameters[key];
        if (!requestParametersString) {
            requestParametersString = @"";
        }
        if (key == [parameters.allKeys firstObject]) {
            requestParametersString = [requestParametersString stringByAppendingFormat:@"%@=%@", key, value];
        }
        else {
            requestParametersString = [requestParametersString stringByAppendingFormat:@"&%@=%@", key, value];
        }
    }
    return requestParametersString;
}

+ (NSDictionary *)requestAuthenHeaderByUIN:(NSString *)uin
                                      sign:(NSString *)sign
                                 timestamp:(NSString *)timestamp
                                    random:(NSString *)random
                                     token:(NSString *)token {
    if ([uin isKindOfClass:[NSNumber class]]) {
        uin = [NSString stringWithFormat:@"%@", uin];
    }
    return [NSDictionary requestParametersByKeysAndValues:
            @"UIN", uin.isNonEmptyString?uin:@"",
            @"Sign", sign.isNonEmptyString?sign:@"",
            @"Timestamp", timestamp.isNonEmptyString?timestamp:@"",
            @"Random", random.isNonEmptyString?random:@"",
            @"Token", token.isNonEmptyString?token:@"",
            OMSParametersEndSignal];
}

+ (BOOL)parametersAreNull:(id)firstObject, ...{
    BOOL result = true;
    va_list arguments;
    id eachObject;
    va_start(arguments, firstObject);
    for (NSInteger i = 0; ; i ++) {
        eachObject = va_arg(arguments, id);
        if ([eachObject isEqual:OMSParametersEndSignal]) {
            break;
        }
        if (eachObject != nil) {
            result = false;
            break;
        }
    }
    va_end(arguments);
    return result;
}

@end
