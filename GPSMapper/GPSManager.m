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
            vAcc=_vAcc,
            fileLock=_fileLock,
            fileName=_fileName;

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
    self.fileLock = [[NSLock alloc] init];
    self.fileName = [NSString stringWithFormat:@"%u.csv", [[NSDate date] timeIntervalSince1970]];
    [@"lat,lng,accuracy,time" writeToFile:self.fileName atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    _hAcc = newLocation.horizontalAccuracy;
    _vAcc = newLocation.verticalAccuracy;
    _position = newLocation.coordinate;
    
//    NSLog(@"New coordinate: (%f,%f), accuracy: %f", _position.latitude, _position.longitude, _hAcc);
    
    NSTimeInterval theTime = [[NSDate date] timeIntervalSince1970];
    
    NSString *csvString = [NSString stringWithFormat:@"%f,%f,%f,%u", _position.latitude, _position.longitude, _hAcc, theTime];
    NSLog(@"%@", csvString);
    
    if ([self.fileLock tryLock])
    {
        [csvString writeToFile:self.fileName atomically:YES encoding:NSUTF8StringEncoding error:NULL];
        
        [self.fileLock unlock];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location manager failed with error: %@", [error description]);
}

- (void)dealloc
{
    [_locationManager release];
    [sharedInstance release];
    [_fileLock release];
    [super dealloc];
}

@end
