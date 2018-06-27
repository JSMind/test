//
//  NSString+Data.m
//  OMSSDK
//
//  Created by OS_HJS on 2017/8/8.
//  Copyright © 2017年 sunniwell. All rights reserved.
//

#import "NSString+OMSData.h"

@implementation NSString (OMSData)

- (NSData *)dataFormat{
    if(self.isNonEmptyString) {
       return [self dataUsingEncoding:NSUTF8StringEncoding];
    }
    else{
        return [@"" dataUsingEncoding:NSUTF8StringEncoding];
    }
}

@end
