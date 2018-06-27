//
//  OMSSocketStack.h
//  OMSSDK
//
//  Created by OS_HJS on 2017/8/9.
//  Copyright © 2017年 sunniwell. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KOMSSocketStack [OMSSocketStack sharedInstance]

typedef enum{
    OMS_MSG_SEND = 1,       //立即发送
    OMS_MSG_SEND_SYNC       //延迟发送
}OMSMessageSendType;

@interface OMSSocketStack : NSObject

@property (nonatomic, strong)NSMutableArray<OMSMessage *>* messageStack;    //消息数组

+ (instancetype)sharedInstance;

/**
 * 获取延迟发送时间间隔
 * @return 延迟发送时间间隔
 */
- (NSTimeInterval)getSendInterval;

/**
 * 设置延迟发送时间间隔
 * @param sendInterval 时间s
 */
- (void)setSendInterval:(NSTimeInterval)sendInterval;

/**
 * 添加一条数据到当前消息中
 * @param logContent 消息体
 */
- (void)addCurrentContent:(OMSLogContent *)logContent;

/**
 * 添加消息到消息队列中
 * @param message 消息
 * @param completion 结果回调
 */
- (void)push:(OMSMessage *)message completion:(OMSSocketDidReadBlock)completion;

/**
 * 将当前消息添加到消息队列中
 */
- (void)pushCurrentMessage;

/**
 * 获取消息队列中最靠前的message
 * @return 消息
 */
- (OMSMessage *)pop;

/**
 * 消息发送成功 将消息从消息队列中移除
 * @param message 消息
 */
- (void)remove:(OMSMessage *)message;

/**
 * 移除消息队列中的所有消息
 */
- (void)removeAllMessage;

/**
 * 根据key值获取对应的block回调
 * @param key key值
 * @return SocketDidReadBlock
 */
- (OMSSocketDidReadBlock)getCompletionForKey:(uint32_t)key;

/**
 * block回调执行后 将block回调从回调字典中移除
 * @param key key值
 */
- (void)removeCompletionForkey:(uint32_t)key;

/**
 * @return 获取消息列表
 */
- (NSArray *)getStackMessageList;

@end


