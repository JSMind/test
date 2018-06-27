//
//  SWHttpRequest.h
//  LSSDK
//
//  Created by Sunniwell on 12/30/16.
//  Copyright © 2016 Sunniwell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMSHttpRequestAPI : NSObject

typedef void(^OMSHttpRequestCallback)(NSURLResponse *response, id responseObject, NSError * error);

/**
 GET方式请求数据 默认10s超时

 @param URLString 请求地址
 @param parameters 请求体参数
 @param headers 头参数
 @param completion 请求结果
 @return sessionId 可以作为取消参数请求使用 -1代表请求url存在问题
 */
+ (NSNumber *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters Headers:(NSDictionary *)headers completion:(OMSHttpRequestCallback)completion;


/**
 GET方式请求数据 自定义超时时间

 @param URLString 请求地址
 @param parameters 请求体参数
 @param headers 头参数
 @param timeout 超时时间  小于等于0按默认10s计算
 @param completion 请求结果
 @return sessionId 可以作为取消参数请求使用 -1代表请求url存在问题

 */
+ (NSNumber *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters Headers:(NSDictionary *)headers timeout:(NSTimeInterval)timeout completion:(OMSHttpRequestCallback)completion;


/**
 Post方式请求数据 带有10s默认超时

 @param URLString 请求地址
 @param parameters 请求体参数
 @param headers 头参数
 @param completion 请求结果
 @return sessionId 可以作为取消参数请求使用 -1代表请求url存在问题
 */
+ (NSNumber *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters Headers:(NSDictionary *)headers completion:(OMSHttpRequestCallback)completion;

/**
 POST方式请求数据 自定义超时时间
 
 @param URLString 请求地址
 @param parameters 请求体参数
 @param headers 头参数
 @param timeout 超时时间 小于等于0按默认10s计算
 @param completion 请求结果
 @return sessionId 可以作为取消参数请求使用 -1代表请求url存在问题
 */
+ (NSNumber *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters Headers:(NSDictionary *)headers timeout:(NSTimeInterval)timeout completion:(OMSHttpRequestCallback)completion;

/**
 取消某个请求

 @param requestId GET或者POST请求返回的ID
 */
- (void)cancelRequestWithId:(NSNumber *)requestId;

@end
