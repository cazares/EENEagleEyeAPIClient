//
//  EENListDevice.m
//  EENEagleEyeAPIClient
//
//  Created by Miguel Cazares on 8/13/14.
//  Copyright (c) 2014 Eagle Eye Networks. All rights reserved.
//

#import "EENListDevice.h"

@implementation EENListDevice

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"accountID": @"account_id",
             @"deviceID": @"id",
             @"name": @"name",
             @"type": @"type",
             @"bridges": @"bridges",
             @"deviceTypeString": @"type",
             @"serviceStatus": @"service_status",
             @"permissions": @"permissions",
             @"tags": @"tags",
             @"guid": @"guid",
             @"serialNumber": @"serial_number",
             @"deviceStatus": @"device_status",
             @"cameraStatus": @"device_status",
             @"timezone": @"timezone",
             @"utcOffsetOrNil": @"timezone_utc_offset",
             @"unsupported": @"is_unsupported",
             @"ip": @"ip_address",
             @"shared": @"is_shared",
             @"ownerAccountName": @"owner_account_name",
             @"isUPNP": @"is_upnp",
             @"videoInput": @"video_input",
             @"videoStatus": @"video_status",
             };
}

+ (NSValueTransformer *)unsupportedJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)sharedJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)isUPNPJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)typeJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *payload) {
        return @([EENDeviceTypes() indexOfObject:payload]);
    } reverseBlock:^(NSNumber *type) {
        return EENDeviceTypes()[type.integerValue];
    }];
}

+ (NSValueTransformer *)serviceStatusJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *payload) {
        return @([EENDeviceServiceStatuses() indexOfObject:payload]);
    } reverseBlock:^(NSNumber *type) {
        return EENDeviceServiceStatuses()[type.integerValue];
    }];
}

+ (NSValueTransformer *)deviceStatusJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^(NSString *payload) {
        unsigned int payloadAsUnsignedInt = (unsigned int)[payload integerValue];
        return @((EENDeviceStatusType)payloadAsUnsignedInt);
    }];
}

+ (NSValueTransformer *)cameraStatusJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^(NSString *payload) {
        unsigned int bitmask = (unsigned int)[payload integerValue];
        EENCameraStatusType cameraStatus;
        if ((bitmask & EENDeviceStatusCameraOn) == 0) {
            cameraStatus = EENCameraStatusOff;
        }
        else if ((bitmask & EENDeviceStatusRegistered) == 0) {
            cameraStatus = EENCameraStatusInternetOffline;
        }
        else if ((bitmask & EENDeviceStatusStreaming) != 0) {
            cameraStatus = EENCameraStatusOnline;
        }
        else if ((bitmask & EENDeviceStatusNeedsPassword) != 0) {
            cameraStatus = EENCameraStatusPasswordNeeded;
        }
        else {
            cameraStatus = EENCameraStatusOffline;
        }
        
        return @(cameraStatus);
    }];
}

@end
