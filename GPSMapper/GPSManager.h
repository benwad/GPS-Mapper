//
//  GPSManager.h
//  GPSMapper
//
//  Created by Ben Wadsworth Fixed on 14/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kCMDesiredGPSFixTaken @"CMDesiredGPSFixTaken"
#define kCMGPSUpdate @"CMGPSUpdate"

@protocol GPSManagerDelegate

@end

@interface GPSManager : NSObject <CLLocationManagerDelegate>
{
    CLLocationCoordinate2D _position;
    CLLocationManager *_locationManager;
    id <GPSManagerDelegate> delegate;
    CLLocationAccuracy _hAcc;
    CLLocationAccuracy _vAcc;
    NSLock *_fileLock;
    
    NSString *_fileName;
}

@property (retain, nonatomic) id <GPSManagerDelegate> delegate;
@property (readonly) CLLocationCoordinate2D gpsCoordinate;
@property (readonly) CLLocationAccuracy hAcc;
@property (readonly) CLLocationAccuracy vAcc;
@property (atomic, retain) NSLock *fileLock;

@property (nonatomic, retain) NSString *fileName;

+ (GPSManager*)sharedInstance;
- (void)start;

@end
