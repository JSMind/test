//
//  SWHttpRequest.m
//  LSSDK
//
//  Created by Sunniwell on 12/30/16.
//  Copyright © 2016 Sunniwell. All rights reserved.
//

#import "OMSHttpRequestAPI.h"
#import <AFNetworking/AFNetworking.h>

#define OMSHttpSharedRequest [OMSHttpRequestAPI sharedInstance]

@interface OMSHttpRequestAPI ()

@property (nonatomic, strong) AFHTTPRequestSerializer *requestSerializer;
@property (nonatomic, strong) AFURLSessionManager *sessionManager;
@property (nonatomic, strong) NSMutableDictionary *dispatchTable;

@end

@implementation OMSHttpRequestAPI

+(OMSHttpRequestAPI *)sharedInstance
{
    static OMSHttpRequestAPI *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[OMSHttpRequestAPI alloc] init];
    });
    return instance;
}

+ (NSNumber *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters Headers:(NSDictionary *)headers completion:(OMSHttpRequestCallback)completion{
    return [OMSHttpSharedRequest dataTaskWithHTTPMethod:@"GET" URLString:URLString parameters:parameters Headers:headers timeout:10 completion:completion];
}

+ (NSNumber *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters Headers:(NSDictionary *)headers completion:(OMSHttpRequestCallback)completion
{
    return [OMSHttpSharedRequest dataTaskWithHTTPMethod:@"POST" URLString:URLString parameters:parameters Headers:headers timeout:10 completion:completion];
}
+ (NSNumber *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters Headers:(NSDictionary *)headers timeout:(NSTimeInterval)timeout completion:(OMSHttpRequestCallback)completion
{
    if (timeout <= 0) {
        timeout = 10;
    }
    return [OMSHttpSharedRequest dataTaskWithHTTPMethod:@"GET" URLString:URLString parameters:parameters Headers:headers timeout:timeout completion:completion];
}

+ (NSNumber *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters Headers:(NSDictionary *)headers timeout:(NSTimeInterval)timeout completion:(OMSHttpRequestCallback)completion
{
    if (timeout <= 0) {
        timeout = 10;
    }
    return [OMSHttpSharedRequest dataTaskWithHTTPMethod:@"POST" URLString:URLString parameters:parameters Headers:headers timeout:timeout completion:completion];
}

- (NSNumber *)dataTaskWithHTTPMethod:(NSString *)method
                           URLString:(NSString *)URLString
                          parameters:(NSDictionary *)parameters
                             Headers:(NSDictionary *)headers
                             timeout:(NSTimeInterval)timeOut
                          completion:(OMSHttpRequestCallback)completion
{
    NSError *serializationError = nil;

    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    if (headers) {
        [self fillAuthenticationHeaders:headers];
    }
    self.requestSerializer.timeoutInterval = timeOut;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:&serializationError];
    if (serializationError) {
        if (completion) {
            dispatch_async(self.sessionManager.completionQueue ?: dispatch_get_main_queue(), ^{
                completion(nil,nil, serializationError);
            });
        }
        return @(-1);
    }
    else {
        __block NSURLSessionDataTask *dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:completion];
        NSNumber *requestId = @([dataTask taskIdentifier]);
        [self.dispatchTable setObject:dataTask forKey:requestId];
        [dataTask resume];
        
        return requestId;
    }
    return @(-1);
}

- (void)fillAuthenticationHeaders:(NSDictionary *)headers
{
    //add headers here
    [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
}
- (void)cancelRequestWithId:(NSNumber *)requestId
{
    NSURLSessionDataTask *task = [self.dispatchTable objectForKey:requestId];
    if (task) {
        [task cancel];
        [self.dispatchTable removeObjectForKey:requestId];
    }
}

- (NSMutableDictionary *)dispatchTable
{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

//- (AFHTTPRequestSerializer *)requestSerializer
//{
//    if (_requestSerializer == nil) {
//        _requestSerializer = [AFHTTPRequestSerializer serializer];
//        _requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
//    }
//    return _requestSerializer;
//}
- (AFJSONResponseSerializer *)responseSerializer
{
    AFJSONResponseSerializer *res = [AFJSONResponseSerializer serializer];
    res.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    return res;
}
- (AFURLSessionManager *)sessionManager
{
    if (!_sessionManager) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        _sessionManager.responseSerializer = [self responseSerializer];
        _sessionManager.completionQueue = dispatch_queue_create("LS.http.request.completion.queue", DISPATCH_QUEUE_SERIAL);;
    }
    return _sessionManager;
}
@end
