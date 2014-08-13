//
//  EENEagleEyeAPIClient.h
//  EENEagleEyeAPIClient
//
//  Created by Miguel Cazares on 8/13/14.
//  Copyright (c) 2014 Eagle Eye Networks. All rights reserved.
//

#import "EENListDevice.h"
#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>

typedef void (^EENEmptyBlock)();
typedef void (^EENGenericBlock)(id);
typedef void (^EENArrayBlock)(NSArray *array);
typedef void (^EENErrorBlock)(NSError *error);

@interface EENEagleEyeAPIClient : NSObject

#pragma mark - aaa - Authentication and authorization

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password;
- (void)authenticateWithVideobankSessionID:(NSString *)sessionID;

#pragma mark - device - Camera and Bridge operations

- (void)getDeviceListWithDeviceType:(EENDeviceType)deviceType
                      serviceStatus:(EENDeviceServiceStatusType)serviceStatus
                            success:(EENArrayBlock)success
                            failure:(EENErrorBlock)failure;

@end
