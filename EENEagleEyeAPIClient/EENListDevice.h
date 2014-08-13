//
//  EENListDevice.h
//  EENEagleEyeAPIClient
//
//  Created by Miguel Cazares on 8/13/14.
//  Copyright (c) 2014 Eagle Eye Networks. All rights reserved.
//

#import <Mantle/Mantle.h>

typedef enum : NSUInteger {
    EENDeviceTypeCamera,
    EENDeviceTypeBridge,
    EENDeviceTypeAny,
} EENDeviceType;

static NSArray *EENDeviceTypes() {
    return @[@"camera", @"bridge", @"any"];
}

typedef enum : NSUInteger {
    EENServiceStatusAny,
    EENServiceStatusAttached,
    EENServiceStatusIdle,
    EENServiceStatusIgnored,
    EENServiceStatusError,
} EENDeviceServiceStatusType;

static NSArray *EENDeviceServiceStatuses() {
    return @[@"ATTD", @"IDLE", @"IGND", @"ERRR"];
}

typedef NS_OPTIONS(NSUInteger, EENDeviceStatusType) {
    EENDeviceStatusRegisteredDeprecated      = (1 << 0),
    EENDeviceStatusOnlineDeprecated          = (1 << 1),
    EENDeviceStatusOnDeprecated              = (1 << 2),
    EENDeviceStatusRecordingDeprecated       = (1 << 3),
    EENDeviceStatusSendingPreviews           = (1 << 4),
    EENDeviceStatusLocated                   = (1 << 5),
    EENDeviceStatusNotSupported              = (1 << 6),
    EENDeviceStatusConfiguring               = (1 << 7),
    EENDeviceStatusNeedsPassword             = (1 << 8),
    EENDeviceStatusAvailable                 = (1 << 9),
    EENDeviceStatusReserved1                 = (1 << 10),
    EENDeviceStatusError                     = (1 << 11),
    EENDeviceStatusReserved2                 = (1 << 12),
    EENDeviceStatusReserved3                 = (1 << 13),
    EENDeviceStatusReserved4                 = (1 << 14),
    EENDeviceStatusReserved5                 = (1 << 15),
    EENDeviceStatusInvalid                   = (1 << 16),
    EENDeviceStatusCameraOn                  = (1 << 17),
    EENDeviceStatusStreaming                 = (1 << 18),
    EENDeviceStatusRecording                 = (1 << 19),
    EENDeviceStatusRegistered                = (1 << 20),
};

typedef enum : NSInteger {
    EENCameraStatusOff,
    EENCameraStatusInternetOffline,
    EENCameraStatusOnline,
    EENCameraStatusPasswordNeeded,
    EENCameraStatusOffline,
    EENCameraStatusNoUpdate,
} EENCameraStatusType;

typedef enum : NSInteger {
    EENRecordingStatusRecording,
    EENRecordingStatusNotRecording,
    EENRecordingStatusNoUpdate,
} EENRecordingStatusType;

@interface EENListDevice : MTLModel <MTLJSONSerializing>

@property (readonly, nonatomic, strong) NSString *accountID;
@property (readonly, nonatomic, strong) NSString *deviceID;
@property (readonly, nonatomic, strong) NSString *name;
@property (readonly, nonatomic, strong) NSString *deviceTypeString;
@property (readonly, nonatomic) EENDeviceType type;
@property (readonly, nonatomic, strong) NSArray *bridges;
@property (readonly, nonatomic) EENDeviceServiceStatusType serviceStatus;
@property (readonly, nonatomic, strong) NSString *permissions;
@property (readonly, nonatomic, strong) NSArray *tags;
@property (readonly, nonatomic, strong) NSString *guid;
@property (readonly, nonatomic, strong) NSString *serialNumber;
@property (readonly, nonatomic) EENDeviceStatusType deviceStatus;
@property (readonly, nonatomic, strong) NSString *timezone;
@property (readonly, nonatomic, strong) NSNumber *utcOffsetOrNil;
@property (readonly, nonatomic) BOOL unsupported;
@property (readonly, nonatomic, strong) NSString *ip;
@property (readonly, nonatomic) BOOL shared;
@property (readonly, nonatomic, strong) NSString *ownerAccountName;
@property (readonly, nonatomic) BOOL isUPNP;
@property (readonly, nonatomic) EENCameraStatusType cameraStatus;

@end
