//
//  NSObject+ModelParser.h
//  LSSDK
//
//  Created by Sunniwell on 1/9/17.
//  Copyright © 2017 Sunniwell. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OMSModelCustomPropertyUtils <NSObject>

@optional

+ (NSDictionary <NSString *, id> *)modelParserCustomPropertyMapper;

+ (NSDictionary<NSString *, id> *)modelParserContainerPropertyGenericClass;

+ (NSArray<NSString *> *)modelParserPropertyBlacklist;

+ (NSArray<NSString *> *)modelParserPropertyWhitelist;

@end

/**
 此类为封装第三方接口用，方便更换第三方工具
 */
@interface NSObject (OMSModelUtils)

+ (id)modelWithJSON:(id)JSON;

+ (id)modelWithDictionary:(NSDictionary *)dictionary;

- (void)modelEncodeWithCoder:(NSCoder *)aCoder;

- (id)modelInitWithCoder:(NSCoder *)aDecoder;

- (id)modelToJSONObject;

- (NSData *)modelToJSONData;

- (NSString *)modelToJSONString;

@end
