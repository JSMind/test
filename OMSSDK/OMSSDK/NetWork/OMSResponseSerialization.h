//
//  LSResponseSerialization.h
//  LiveSunniwellSDK
//
//  Created by 朱盛雄 on 2017/4/27.
//  Copyright © 2017年 朱盛雄. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OMSResponse;

typedef void(^OMSBaseCompletion)(OMSResponse *response, NSError *error);
typedef void(^OMSBOOLCompletion)(BOOL result, NSError *error);
typedef void(^OMSArrayCompletion)(NSArray *array, NSError *error);
typedef void(^OMSModelCompletion)(id model, NSError *error);

@interface OMSResponse : NSObject

@property (nonatomic, assign)NSInteger code;

@property (nonatomic, strong)NSString *msg;

@property (nonatomic, strong)id result;

@end

@interface OMSResponseSerialization : NSObject

+ (id)responseDataSerializationWith:(id)data modelClass:(Class)aClass;

@end
