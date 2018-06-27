//
//  OMSMessage.h
//  OMSSDK
//
//  Created by OS_HJS on 2017/8/8.
//  Copyright © 2017年 sunniwell. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class OMSHead;

@interface OMSMessage : NSObject

@property (nonatomic, strong)OMSContent *mContent;
@property (nonatomic, strong)OMSHead *mHead;
@property (nonatomic, strong)NSMutableData *contentData;


/**
 * 创建message
 * @param head 包头
 * @param content 报文内容体
 * @return OMSMessage对象
 */
- (instancetype)initWithHead:(OMSHead *)head content:(OMSContent *)content;

- (void)addContent:(OMSContent *)content;

/**
 * 将message转化为NSData
 * @return NSData数据
 */
- (NSData *)getDataBytes;

@end


@interface OMSLoginMessage : OMSMessage

- (instancetype)initWithTIN:(NSNumber *__nonnull)tin
                        uin:(NSNumber *__nonnull)uin
               terminalType:(OMSTerminalType)terminalType;

@end

@interface OMSHeartMessage : OMSMessage

- (instancetype)initWithTIN:(NSNumber *__nonnull)tin
                        uin:(NSNumber *__nonnull)uin;

@end

@interface OMSLogMessage : OMSMessage

- (instancetype)initWithLogContent:(OMSLogContent *)logContent;

@end

NS_ASSUME_NONNULL_END















