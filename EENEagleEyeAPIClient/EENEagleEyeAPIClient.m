//
//  EENEagleEyeAPIClient.m
//  EENEagleEyeAPIClient
//
//  Created by Miguel Cazares on 8/13/14.
//  Copyright (c) 2014 Eagle Eye Networks. All rights reserved.
//

#import "EENEagleEyeAPIClient.h"

static NSString * const kEENAPIBaseURLString = @"https://login.eagleeyenetworks.com/";

typedef void (^EENRequestOperationSuccessBlock)(AFHTTPRequestOperation *operation, NSDictionary *response);
typedef void (^EENRequestOperationGenericBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^EENRequestOperationFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

typedef enum : NSUInteger {
    EENGetHttpMethod,
    EENPutHttpMethod,
    EENPostHttpMethod,
    EENDeleteHttpMethod,
} EENHttpMethodType;

@interface EENEagleEyeAPIClient ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) NSString *sessionID;

@end

@implementation EENEagleEyeAPIClient

- (id)init {
    self = [super init];
    if (self) {
        self.manager = [AFHTTPRequestOperationManager manager];
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

- (void)apiRequestWithMethod:(EENHttpMethodType)httpMethod
                        path:(NSString *)path
                  parameters:(NSDictionary *)parameters
                     success:(EENRequestOperationSuccessBlock)successBlock {
    path = [NSString stringWithFormat:@"%@%@", kEENAPIBaseURLString, path];
    EENRequestOperationFailureBlock failure = ^(AFHTTPRequestOperation *operation, NSError* error){ NSLog(@"Error: %@", error); };
    EENRequestOperationGenericBlock success = ^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
        successBlock(operation, response);
    };
    switch (httpMethod) {
        case EENGetHttpMethod:
            [self.manager GET:path parameters:parameters success:success failure:failure];
            break;
            
        case EENPutHttpMethod:
            [self.manager PUT:path parameters:parameters success:success failure:failure];
            break;
            
        case EENPostHttpMethod:
            [self.manager POST:path parameters:parameters success:success failure:failure];
            break;
            
        case EENDeleteHttpMethod:
            [self.manager DELETE:path parameters:parameters success:success failure:failure];
            break;
    }
}

#pragma mark - aaa - Authentication and authorization

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password {
    [self apiRequestWithMethod:EENPostHttpMethod
          path:@"g/aaa/authenticate"
    parameters:@{ @"username": username, @"password": password }
       success:^(AFHTTPRequestOperation *operation, NSDictionary *response) {
           [self apiRequestWithMethod:EENPostHttpMethod
             path:@"g/aaa/authorize"
       parameters:@{ @"token": response[@"token"]}
          success:^(AFHTTPRequestOperation *operation, NSDictionary *response) {
               NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:operation.response.allHeaderFields
                                                                         forURL:operation.response.URL];
               if (cookies.count > 0) {
                   NSHTTPCookie *cookie = (NSHTTPCookie *)cookies[0];
                   self.sessionID = cookie.value;
               }
          }];
    }];
}

- (void)authenticateWithVideobankSessionID:(NSString *)sessionID {
    self.sessionID = sessionID;
}

#pragma mark - device - Camera and Bridge operations

- (void)getDeviceListWithDeviceType:(EENDeviceType)deviceType
                      serviceStatus:(EENDeviceServiceStatusType)serviceStatus
                            success:(EENArrayBlock)success
                            failure:(EENErrorBlock)failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"A"] = self.sessionID;
    if (deviceType != EENDeviceTypeAny) {
        parameters[@"t"] = EENDeviceTypes()[deviceType];
    }
    if (serviceStatus != EENDeviceTypeAny) {
        parameters[@"s"] = EENDeviceServiceStatuses()[serviceStatus];
    }
    [self apiRequestWithMethod:EENGetHttpMethod
      path:@"g/device/list"
parameters:parameters
   success:^(AFHTTPRequestOperation *operation, NSDictionary *response) {
       NSMutableArray *devices = [NSMutableArray array];
       for (NSArray *item in response) {
           NSDictionary *itemDictionary = @{
                                            @"account_id":          item[0],
                                            @"id":                  item[1],
                                            @"name":                item[2],
                                            @"type":                item[3],
                                            @"bridges":             item[4],
                                            @"service_status":      item[5],
                                            @"permissions":         item[6],
                                            @"tags":                item[7],
                                            @"guid":                item[8],
                                            @"serial_number":       item[9],
                                            @"device_status":       item[10],
                                            @"camera_status":       item[10],
                                            @"timezone":            item[11],
                                            @"timezone_utc_offset": item[12],
                                            @"is_unsupported":      item[13],
                                            @"ip_address":          item[14],
                                            @"is_shared":           item[15],
                                            @"owner_account_name":  item[16],
                                            @"is_upnp":             item[17],
                                            @"video_input":         item[18],
                                            @"video_status":        item[19],
                                            };
           EENListDevice *device = [MTLJSONAdapter modelOfClass:[EENListDevice class]
                                             fromJSONDictionary:itemDictionary
                                                          error:nil];
           [devices addObject:device];
       }
       success(devices);
    }];
}

@end
