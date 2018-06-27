//
//  NSString+Transfer.m
//  LiveSunniwellSDK
//
//  Created by 朱盛雄 on 2017/4/28.
//  Copyright © 2017年 朱盛雄. All rights reserved.
//

#import "NSString+OMSCoder.h"

@implementation NSString (OMSCoder)

- (NSString *)encodeToPercentEscapeString {
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
    
}

- (NSString *)decodeFromPercentEscapeString {
    NSString *encodedString = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
}

@end
