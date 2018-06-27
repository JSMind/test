//
//  NSData+Parameter.h
//  OMSSDK
//
//  Created by OS_HJS on 2017/8/8.
//  Copyright © 2017年 sunniwell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (OMSParameter)

+ (NSData *)appendParameters:(id)firstObject, ...;

@end
