//
//  SWErrorManager.m
//  LSSDK
//
//  Created by Sunniwell on 1/3/17.
//  Copyright © 2017 Sunniwell. All rights reserved.
//

#import "OMSError.h"


static NSString *const ls_error_domin = @"ls.error.domin";


// 服务器定义错误信息
#define OMS_REQUEST_TIMEOUT                @"请求超时"
#define OMS_REQUEST_PARAM_ERROR            @"入参错误"
#define OMS_REQUEST_ERROR                  @"请求失败"
#define OMS_SERVER_MAINTENANCE_UPDATES     @"用户状态丢失"
#define OMS_AUTHAPPRAISAL_FAILED           @"Token 失效"
// SDK内定义错误信息
#define OMS_NETWORK_DISCONNECTED           @"网络断开"
#define OMS_LOCAL_REQUEST_TIMEOUT          @"本地请求超时"
#define OMS_JSON_PARSE_ERROR               @"JSON 解析错误"
#define OMS_LOCAL_PARAM_ERROR              @"本地入参错误"


@implementation OMSError

+ (NSError *)errorWithErrorCode:(OMSErrorCode)errorCode {
    NSString *errorMessage;
    switch (errorCode) {
        case OMSErrorCode_REQUEST_ERROR:
            errorMessage = OMS_REQUEST_ERROR;
            errorCode = 1001;
            break;
        case OMSErrorCode_REQUEST_PARAM_ERROR:
            errorMessage = OMS_REQUEST_PARAM_ERROR;
            errorCode = 1002;
            break;
        case OMSErrorCode_REQUEST_TIMEOUT:
            errorMessage = OMS_REQUEST_TIMEOUT;
            errorCode = 1003;
            break;
        case OMSErrorCode_SERVER_MAINTENANCE_UPDATES:
            errorMessage = OMS_SERVER_MAINTENANCE_UPDATES;
            errorCode = 1004;
            break;
        case OMSErrorCode_AUTHAPPRAISAL_FAILED:
            errorMessage = OMS_AUTHAPPRAISAL_FAILED;
            break;
        case OMSErrorCode_NETWORK_DISCONNECTED:
            errorMessage = OMS_NETWORK_DISCONNECTED;
            break;
        case OMSErrorCode_LOCAL_REQUEST_TIMEOUT:
            errorMessage = OMS_LOCAL_REQUEST_TIMEOUT;
            break;
        case OMSErrorCode_JSON_PARSE_ERROR:
            errorMessage = OMS_JSON_PARSE_ERROR;
            break;
        case OMSErrorCode_LOCAL_PARAM_ERROR:
            errorMessage = OMS_LOCAL_PARAM_ERROR;
            break;
        default:
            break;
    }
    return [NSError errorWithDomain:NSURLErrorDomain
                               code:errorCode
                           userInfo:@{ NSLocalizedDescriptionKey: errorMessage }];
}

+ (NSError *)errorWithRepsonseData:(OMSResponse *)data {
    return [NSError errorWithDomain:ls_error_domin
                               code:data.code
                           userInfo:[NSDictionary requestParametersByKeysAndValues:
                                     @"msg",data.msg,
                                     OMSParametersEndSignal]];
}

+ (NSError *)errorWithInvaildRequestParameter {
    return [NSError errorWithDomain:ls_error_domin
                               code:-2249
                           userInfo:@{@"msg":@"parameter invaild"}];
}

+ (OMSResponse *)responseForError:(NSError *)error {
    OMSResponse *response = [[OMSResponse alloc] init];
    response.code = error.code;
    response.msg = error.userInfo[NSLocalizedDescriptionKey];
    response.result = nil;
    return response;
}

+ (OMSResponse *)responseForParameterError {
    OMSResponse *response = [[OMSResponse alloc] init];
    response.code = -2249;
    response.msg = @"parameter invaild";
    response.result = nil;
    return response;
}

@end
