//
//  SWErrorManager.h
//  LSSDK
//
//  Created by Sunniwell on 1/3/17.
//  Copyright © 2017 Sunniwell. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,OMSErrorCode) {
    OMSErrorCode_REQUEST_TIMEOUT,
    OMSErrorCode_REQUEST_PARAM_ERROR,
    OMSErrorCode_REQUEST_ERROR,
    OMSErrorCode_SERVER_MAINTENANCE_UPDATES,
    OMSErrorCode_AUTHAPPRAISAL_FAILED,
    OMSErrorCode_NETWORK_DISCONNECTED,
    OMSErrorCode_LOCAL_REQUEST_TIMEOUT,
    OMSErrorCode_JSON_PARSE_ERROR,
    OMSErrorCode_LOCAL_PARAM_ERROR,
};

@interface OMSError : NSObject

+ (NSError *)errorWithErrorCode:(OMSErrorCode)errorCode;

+ (NSError *)errorWithRepsonseData:(OMSResponse *)data;

+ (NSError *)errorWithInvaildRequestParameter;

+ (OMSResponse *)responseForError:(NSError *)error;

+ (OMSResponse *)responseForParameterError;

@end
