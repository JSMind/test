//
//  SWMessageClient.h
//  LSSDK
//
//  Created by Sunniwell on 12/30/16.
//  Copyright © 2016 Sunniwell. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KOMSSocketApi [OMSSocketApi sharedInstance]

typedef void (^OMSSocketStatusBlock)(BOOL isConnect);
typedef void (^OMSSocketDidReadBlock)(NSError * error, id data);

typedef enum {
    OMS_SOCKET_DISCONNECTED = -1,
    OMS_SOCKET_CONNECTING = 0,
    OMS_SOCKET_CONNECTED = 1
}OMSSocketConnectStatus;

typedef enum {
    OMS_SOCKET_METHOD_GET = 0,
    OMS_SOCKET_METHOD_POST = 1,
}OMSSocketMethod;

@protocol  OMSSocketDelegate <NSObject>

@optional
- (void)OnSocketConnectSuccess:(NSString *)host port:(int)port;
- (void)OnSocketDisConnect:(NSError *)err;

@required
//- (void)OnReceiveServerMsg:(NSData *)data;
- (void)OnReceiveServerMsg:(NSData *)data omsCmd:(int)omsCmd omsSessionId:(long long)omsSessionId;

@end

@interface OMSSocketRequestMap : NSObject

@property (atomic,assign)BOOL isUsed;
@property (nonatomic,copy)OMSSocketDidReadBlock completion;

@end

@class OMSMessage;

@interface OMSSocketApi : NSObject

@property (nonatomic, weak)id<OMSSocketDelegate> delegate;
@property (nonatomic, strong)dispatch_queue_t delegateQueue;

/**
 *  连接状态：1已连接，-1未连接，0连接中
 */
@property (nonatomic, assign)OMSSocketConnectStatus connectStatus;

+ (OMSSocketApi *)sharedInstance;

/**
 连接socket 无超时时间
 
 @param host 主机域名或者ip
 @param port 端口号
 @param errPtr 错误信息
 @return 是否成功
 */
- (BOOL)connectToHost:(NSString *)host onPort:(uint16_t)port error:(NSError **)errPtr;

/**
 连接socket

 @param host 主机域名或者ip
 @param port 端口号
 @param timeout 超时时间
 @param errPtr 错误信息
 @return 是否成功
 */
- (BOOL)connectToHost:(NSString *)host
               onPort:(uint16_t)port
          withTimeout:(NSTimeInterval)timeout
                error:(NSError **)errPtr;

/**
 *  向服务器发送数据
 *
 *  @param body    请求体
 */
- (void)socketWriteDataWithMethod:(OMSSocketMethod)method
                      RequestPath:(NSString *)path
                      RequestBody:(NSString *)body
                    RequestHeader:(NSDictionary *)header
                       completion:(OMSSocketDidReadBlock)completion;

- (void)socketWriteDataWithMessage:(OMSMessage *)message
                        completion:(OMSSocketDidReadBlock)completion;

//断开连接
- (void)disconnect;

//socket状态改变
- (void)socketStatusChange:(OMSSocketStatusBlock)statusBlock;

////处理网络不同状况 sdk中统一一个地方管理网络状况
//- (void)dealWithNetwork:(BOOL)isNetWorkDown;

@end
