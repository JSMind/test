//
//  NSString+Transfer.h
//  LiveSunniwellSDK
//
//  Created by 朱盛雄 on 2017/4/28.
//  Copyright © 2017年 朱盛雄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (OMSCoder)

- (NSString *)encodeToPercentEscapeString;

- (NSString *)decodeFromPercentEscapeString;

@end
