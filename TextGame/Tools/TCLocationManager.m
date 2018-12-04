//
//  TCLocationManager.m
//  定位与编码
//
//  Created by william on 2016/11/2.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import "TCLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface TCLocationManager()<CLLocationManagerDelegate>

//定位管理类
@property (nonatomic,strong) CLLocationManager* locationManager;

@property (nonatomic,strong) NSRunLoop *runloop;

@property (nonatomic,strong) NSPort *port;

@end

@implementation TCLocationManager

- (void)location{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _runloop = [NSRunLoop currentRunLoop];
        _port = [NSMachPort port];
        [_runloop addPort:_port forMode:NSDefaultRunLoopMode];
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        [self startLocation];
        [_runloop run];
    });
}

- (void)startLocation
{
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    NSLog(@"开始定位");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //逆地理编码
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error || [placemarks count] == 0)
        {
            NSLog(@"逆地理编码错误,error = %@", error);
            return;
        }
        NSDictionary *addressDic = [[placemarks objectAtIndex:0] addressDictionary];
        [_runloop removePort:_port forMode:NSDefaultRunLoopMode];
        if (_locationSuccess) {
            _locationSuccess(addressDic);
        }
        NSLog(@"dic = %@",addressDic);
    }];
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
    }
    NSLog(@"定位失败");
}

@end
