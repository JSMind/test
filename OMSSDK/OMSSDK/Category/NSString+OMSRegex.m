//
//  NSString+Regex.m
//  MopSDK
//
//  Created by 朱盛雄 on 1/11/17.
//  Copyright © 2017 Sunniwell. All rights reserved.
//

#import "NSString+OMSRegex.h"

@implementation NSString (OMSRegex)

- (BOOL)isNonEmptyString {
    return ![[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""];
}

- (BOOL)isPhoneNumber {
    if (self.length != 11) {
        return NO;
    }
    else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:self];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:self];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:self];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }
        else{
            return NO;
        }
    }
}

- (BOOL)isContainingSpecialCharacter {
    NSString *pattern = @"^[\\w\u4E00-\u9FA5\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return !isMatch;
}

- (NSString *)noNullStr
{
    if (self.isNonEmptyString) {
        return self;
    }
    else
    {
        return @"";
    }
}

- (BOOL)isPassword
{
   return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$"] evaluateWithObject: self];
}


//- (NSString *)encodeToPercentEscapeString
//{
//    NSString *encodedString = (NSString *)
//    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                              (CFStringRef)self,
//                                                              NULL,
//                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
//                                                              kCFStringEncodingUTF8));
//    
//    return encodedString;
//    
//}
//
//
//- (NSString *)decodeFromPercentEscapeString
//{
//    NSString *encodedString = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
//    return [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//}
@end
