//
//  GPSManager.m
//  GPSMapper
//
//  Created by Ben Wadsworth Fixed on 14/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GPSManager.h"

static GPSManager *sharedInstance;

@implementation GPSManager

@synthesize delegate,
            gpsCoordinate=_gpsCoordinate,
            hAcc=_hAcc,
            vAcc=_vAcc;

- (id)initManager
{
    self = [super init];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    return self;
}

+ (GPSManager *)sharedInstance
{
    @synchronized(self)
    {
        if (!sharedInstance)
            sharedInstance = [[GPSManager alloc] initManager];
    }
    return sharedInstance;
}

- (void)start
{
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    _hAcc = newLocation.horizontalAccuracy;
    _vAcc = newLocation.verticalAccuracy;
    _position = newLocation.coordinate;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location manager failed with error: %@", [error description]);
}

- (void)dealloc
{
    [_locationManager release];
    [sharedInstance release];
    [super dealloc];
}

@end
