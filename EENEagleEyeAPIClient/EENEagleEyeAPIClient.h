//
//  EENEagleEyeAPIClient.h
//  EENEagleEyeAPIClient
//
//  Created by Miguel Cazares on 8/13/14.
//  Copyright (c) 2014 Eagle Eye Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface EENEagleEyeAPIClient : NSObject

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password;

@end
