//
//  NSString+JSON.m
//  WebRTCDemo
//
//  Created by 朱盛雄 on 16/9/30.
//  Copyright © 2016年 朱盛雄. All rights reserved.
//

#import "NSString+OMSJSON.h"

@implementation NSString (OMSJSON)

- (NSDictionary *)dictionaryFormat {
    NSData *strData = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:strData options:NSJSONReadingMutableContainers error:nil];
}

@end
