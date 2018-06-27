//
//  NSString+Regex.h
//  MopSDK
//
//  Created by 朱盛雄 on 1/11/17.
//  Copyright © 2017 Sunniwell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (OMSRegex)

- (BOOL)isNonEmptyString;

- (BOOL)isPhoneNumber;

- (BOOL)isContainingSpecialCharacter;

- (NSString *)noNullStr;

- (BOOL)isPassword;

//- (NSString *)encodeToPercentEscapeString;
//
//- (NSString *)decodeFromPercentEscapeString;

@end
