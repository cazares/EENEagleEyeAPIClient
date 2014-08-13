//
//  EENEagleEyeAPIClient.m
//  EENEagleEyeAPIClient
//
//  Created by Miguel Cazares on 8/13/14.
//  Copyright (c) 2014 Eagle Eye Networks. All rights reserved.
//

#import "EENEagleEyeAPIClient.h"

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

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password {
    NSDictionary *parameters = @{ @"username": username,
                                  @"password": password };
    [self.manager POST:@"https://login.eagleeyenetworks.com/g/aaa/authenticate"
        parameters:parameters
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               NSError *error;
               NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                        options:NSJSONReadingAllowFragments
                                                                          error:&error];
               NSDictionary *parameters = @{ @"token": response[@"token"] };
               [self.manager POST:@"https://login.eagleeyenetworks.com/g/aaa/authorize"
                   parameters:parameters
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:operation.response.allHeaderFields
                                                                                    forURL:operation.response.URL];
                          if (cookies.count > 0) {
                              NSHTTPCookie *cookie = (NSHTTPCookie *)cookies[0];
                              self.sessionID = cookie.value;
                          }
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"Error: %@", error);
                      }];
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               NSLog(@"Error: %@", error);
           }];
}

@end
