//
//  NSObject+ModelParser.m
//  LSSDK
//
//  Created by Sunniwell on 1/9/17.
//  Copyright © 2017 Sunniwell. All rights reserved.
//

#import "NSObject+OMSModelUtils.h"
#import "YYModel.h"

@interface NSObject ()<YYModel>

@end

@implementation NSObject (OMSModelUtils)

+ (instancetype)modelWithJSON:(id)JSON {
    return [self yy_modelWithJSON:JSON];
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    return [self yy_modelWithDictionary:dictionary];
}

- (id)modelToJSONObject {
    return [self yy_modelToJSONObject];
}

- (NSData *)modelToJSONData
{
    return [self yy_modelToJSONData];
}

- (NSString *)modelToJSONString {
    return [self yy_modelToJSONString];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    Class class = [self class];
    if ([class respondsToSelector:@selector(modelParserCustomPropertyMapper)]) {
        NSDictionary *dict = [(id<OMSModelCustomPropertyUtils>)class modelParserCustomPropertyMapper];
        return dict;
    }
    return nil;
}

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    Class class = [self class];
    if ([class respondsToSelector:@selector(modelParserContainerPropertyGenericClass)]) {
        NSDictionary *dict = [(id<OMSModelCustomPropertyUtils>)class modelParserContainerPropertyGenericClass];
        return dict;
    }
    return nil;
}

+ (NSArray *)modelPropertyWhitelist {
    Class class = [self class];
    if ([class respondsToSelector:@selector(modelParserPropertyWhitelist)]) {
        NSArray *dataArray = [(id<OMSModelCustomPropertyUtils>)class modelParserPropertyWhitelist];
        return dataArray;
    }
    return nil;
}

+ (NSArray *)modelPropertyBlacklist {
    Class class = [self class];
    if ([class respondsToSelector:@selector(modelParserPropertyBlacklist)]) {
        NSArray *dataArray = [(id<OMSModelCustomPropertyUtils>)class modelParserPropertyBlacklist];
        return dataArray;
    }
    return nil;
}

- (void)modelEncodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)modelInitWithCoder:(NSCoder *)aDecoder {
    return [self yy_modelInitWithCoder:aDecoder];
}

@end
