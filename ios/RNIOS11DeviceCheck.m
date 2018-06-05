//
// Copyright © 2017-Present, Gaurav D. Sharma
// All rights reserved.
//

#import "RNIOS11DeviceCheck.h"
#import <DeviceCheck/DeviceCheck.h>

typedef void (^FailureHandleErrorBlock)(NSError* error, NSString *errorType);

@implementation RNIOS11DeviceCheck
RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(getToken:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    FailureHandleErrorBlock failureBlock = ^void(NSError* error, NSString *errorType) {
        NSString *errorDomain = [NSString stringWithFormat:@"com.apple.devicecheck.error.%@", errorType ?: @"ios-version-not-supported"];
        if (!error) {
            error = [[NSError alloc] initWithDomain:errorDomain
                                               code:400
                                           userInfo:@{
                                                      NSLocalizedDescriptionKey: @"This device does not support the apple devicecheck, due to below iOS 11 version or simulator."
                                                      }];
        }
        reject(errorDomain, error.localizedDescription, error);
    };
    
    if (@available(iOS 11.0, *)) {
        if (DCDevice.currentDevice.supported) {
            [DCDevice.currentDevice generateTokenWithCompletionHandler:^(NSData * _Nullable token, NSError * _Nullable error) {
                if (!error && token && token.length > 0) {
                    NSData *data64 = [token base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    NSString *token64 = [[NSString alloc] initWithData:data64 encoding:NSUTF8StringEncoding];
                    resolve(token64);
                } else if (error) {
                    failureBlock(error, @"cannot-create");
                } else {
                    failureBlock(nil, @"unknown-trouble-to-create-token");
                }
            }];
        } else {
            failureBlock(nil, @"device-not-supported");
        }
    } else {
        failureBlock(nil, nil);
    }
}

@end