//
// Copyright © 2017-Present, Gaurav D. Sharma
// All rights reserved.
//

#import "RNIOS11DeviceCheck.h"
#import <DeviceCheck/DeviceCheck.h>
#import <CommonCrypto/CommonDigest.h>

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

RCT_EXPORT_METHOD(generateKey:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    FailureHandleErrorBlock failureBlock = ^void(NSError* error, NSString *errorType) {
        NSString *errorDomain = [NSString stringWithFormat:@"com.apple.devicecheck.error.%@", errorType ?: @"ios-version-not-supported"];
        if (!error) {
            error = [[NSError alloc] initWithDomain:errorDomain
                code:400
                userInfo:@{NSLocalizedDescriptionKey: @"This device does not support Apple AppAttest API, due to below iOS 14 version or simulator."}
            ];
        }
        reject(errorDomain, error.localizedDescription, error);
    };
    
    if (@available(iOS 14.0, *)) {
        if (DCAppAttestService.sharedService.isSupported) {
            [DCAppAttestService.sharedService generateKeyWithCompletionHandler:^(NSString * _Nullable keyId, NSError * _Nullable error) {
                if (!error && keyId && keyId.length > 0) {
                    resolve(keyId);
                } else if (error) {
                    failureBlock(error, @"cannot-create");
                } else {
                    failureBlock(nil, @"unknown-trouble-to-generate-key");
                }
            }];
        } else {
            failureBlock(nil, @"device-not-supported");
        }
    } else {
        failureBlock(nil, nil);
    }
}

RCT_EXPORT_METHOD(attestKey:(NSString *)keyId
                  challenge:(NSString *)challenge
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    FailureHandleErrorBlock failureBlock = ^void(NSError* error, NSString *errorType) {
        NSString *errorDomain = [NSString stringWithFormat:@"com.apple.devicecheck.error.%@", errorType ?: @"ios-version-not-supported"];
        if (!error) {
            error = [[NSError alloc] initWithDomain:errorDomain
                code:400
                userInfo:@{NSLocalizedDescriptionKey: @"This device does not support Apple AppAttest API, due to below iOS 14 version or simulator."}
            ];
        }
        reject(errorDomain, error.localizedDescription, error);
    };
    
    if (@available(iOS 14.0, *)) {
        if (DCAppAttestService.sharedService.isSupported) {
            NSData* data = [challenge dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableData *sha256Data = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
            CC_SHA256([data bytes], (CC_LONG)[data length], [sha256Data mutableBytes]);
            NSData * clientDataHash = [NSData dataWithData:sha256Data];

            [DCAppAttestService.sharedService attestKey:keyId clientDataHash:clientDataHash completionHandler:^(NSData * _Nullable attestationObject, NSError * _Nullable error) {
                if (!error && attestationObject) {
                    NSData *data64 = [attestationObject base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    NSString *attestation64 = [[NSString alloc] initWithData:data64 encoding:NSUTF8StringEncoding];
                    resolve(attestation64);
                } else if (error) {
                    failureBlock(error, @"cannot-attest");
                } else {
                    failureBlock(nil, @"unknown-trouble-to-attest-key");
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