//
//  OMSSerVerItem.h
//  OMSSDK
//
//  Created by OS_HJS on 2017/8/7.
//  Copyright © 2017年 sunniwell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMSServerItem : NSObject

@property (nonatomic, strong)NSString *host;
@property (nonatomic, strong)NSNumber *http_port;
@property (nonatomic, strong)NSNumber *https_port;

@end


@interface OMSAccessItem : OMSServerItem

@property (nonatomic, strong)NSNumber *ws_port;             //websocketPort
@property (nonatomic, strong)NSNumber *wss_port;            //websocketsPort
@property (nonatomic, strong)NSNumber *private_port;        //socket port
@property (nonatomic, strong)NSNumber *privates_port;       //
@property (nonatomic, strong)NSString *domain;

@end
