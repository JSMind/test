//
//  LSResponse.m
//  LiveSunniwellSDK
//
//  Created by 朱盛雄 on 2017/4/27.
//  Copyright © 2017年 朱盛雄. All rights reserved.
//

#import "OMSResponseSerialization.h"

@implementation OMSResponse

- (NSString *)description {
    return [NSString stringWithFormat:@"{\n\tcode:%ld\n\tmsg:%@\nresult:%@\n}", self.code, self.msg, self.result];
}

@end

@implementation OMSResponseSerialization

+ (id)responseDataSerializationWith:(id)data modelClass:(Class)aClass {
    id result = nil;
    if ([data isKindOfClass:[NSArray class]]) {
        result = [NSMutableArray array];
        for (NSDictionary *modelDict in data) {
            NSObject *model = [aClass modelWithDictionary:modelDict];
            [result addObject:model];
        }
    }
    else if ([data isKindOfClass:[NSDictionary class]]) {
        result = [aClass modelWithDictionary:data];
    }
    return result;
}


@end
