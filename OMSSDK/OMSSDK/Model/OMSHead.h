//
//  OMSHead.h
//  OMSSDK
//
//  Created by OS_HJS on 2017/8/9.
//  Copyright © 2017年 sunniwell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMSHead : NSObject

@property (nonatomic, assign)uint32_t mPackageLength;     //整个报文长度
@property (nonatomic, assign)uint16_t mHeadLengh;         //包头长度
@property (nonatomic, assign)uint16_t mVersion;           //协议版本
@property (nonatomic, assign)uint32_t mCommand;               //指令
@property (nonatomic, assign)uint32_t mSessionId;               //请求序号，递增

- (NSData *)headDataFormat;

@end
