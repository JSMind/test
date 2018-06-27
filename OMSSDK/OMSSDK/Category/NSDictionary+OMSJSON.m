//
//  NSDictionary+JSON.m
//  WebRTCDemo
//
//  Created by 朱盛雄 on 16/9/30.
//  Copyright © 2016年 朱盛雄. All rights reserved.
//

#import "NSDictionary+OMSJSON.h"

@implementation NSDictionary (OMSJSON)

- (NSString *)stringFormat {
    NSData *dictData = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    return [[NSString alloc] initWithData:dictData encoding:NSUTF8StringEncoding];
}

@end
