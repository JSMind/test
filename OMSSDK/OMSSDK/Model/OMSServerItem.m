//
//  OMSSerVerItem.m
//  OMSSDK
//
//  Created by OS_HJS on 2017/8/7.
//  Copyright © 2017年 sunniwell. All rights reserved.
//

#import "OMSServerItem.h"

@interface OMSServerItem ()<OMSModelCustomPropertyUtils>

@end

@implementation OMSServerItem

- (void)modelEncodeWithCoder:(NSCoder *)aCoder{
    [self modelEncodeWithCoder:aCoder];
}

- (id)modelInitWithCoder:(NSCoder *)aDecoder{
    return [self modelInitWithCoder:aDecoder];
}

@end


@interface OMSAccessItem ()<OMSModelCustomPropertyUtils>

@end

@implementation OMSAccessItem

- (void)modelEncodeWithCoder:(NSCoder *)aCoder{
    [self modelEncodeWithCoder:aCoder];
}

- (id)modelInitWithCoder:(NSCoder *)aDecoder{
    return [self modelInitWithCoder:aDecoder];
}

@end
