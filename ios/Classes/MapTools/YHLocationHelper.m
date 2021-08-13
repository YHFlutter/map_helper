//
//  YHLocationHelper.m
//  YHCommonUI
//
//  Created by Waynn on 2020/9/10.
//

#import "YHLocationHelper.h"
#import "YHLocationConverter.h"

@interface YHLocationHelper() <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *manager;

@property (nonatomic, copy, nullable) void(^didGetLocationBlock)(CLLocation *location);

@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation YHLocationHelper

static YHLocationHelper *helper = nil;
+ (instancetype)sharedHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [YHLocationHelper new];
        [helper manager];
    });

    return helper;
}

- (void)requestLocationWithBlock:(void (^)(CLLocation * _Nonnull))block {
    [self.manager requestLocation];

    _didGetLocationBlock = block;
}

- (CLLocation *)currentLoaction {
    return self.manager.location;
}

- (void)startUpdatingLocation {
    [self.manager startUpdatingLocation];
}

- (void)stopUpdatingLocation {
    [self.manager stopUpdatingLocation];
}

- (CLLocationCoordinate2D)currentCoordinateBySystem:(YHCoordinateSystem)system {
    
    CLLocationCoordinate2D coordinate = self.currentLoaction.coordinate;
    switch (system) {
        case YHCoordinateSystem_GCJ:
            return [YHLocationConverter wgs84ToGcj02:coordinate];
        case YHCoordinateSystem_BD:
            return [YHLocationConverter wgs84ToBd09:coordinate];
        case YHCoordinateSystem_WGS:
            return coordinate;
        default:
            return coordinate;
    }
}

/* =========================================== */

- (void)reverseGeocodeLocation:(CLLocation *)location
             completionHandler:(CLGeocodeCompletionHandler)completionHandler {
    [self.geocoder reverseGeocodeLocation:location completionHandler:completionHandler];
}

- (void)geocodeAddressString:(NSString *)addressString inRegion:(nullable CLRegion *)region completionHandler:(CLGeocodeCompletionHandler)completionHandler {
    [self.geocoder geocodeAddressString:addressString inRegion:region completionHandler:completionHandler];
}

/* =========================================== */
#pragma mark - Getter Setter
/* =========================================== */

- (CLLocationManager *)manager {
    if (_manager == nil) {
        _manager = [[CLLocationManager alloc] init];
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        _manager.delegate = self;
        
        self.authorizationStatus = [CLLocationManager authorizationStatus];
    }

    return _manager;
}

- (void)setDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy {
    self.manager.desiredAccuracy = desiredAccuracy;
}

- (CLGeocoder *)geocoder {
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }

    return _geocoder;
}

/* =========================================== */
#pragma mark - CLLocationManagerDelegate
/* =========================================== */

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusNotDetermined) {
        [manager requestWhenInUseAuthorization];
    }
    if (self.authorizationStatus == kCLAuthorizationStatusNotDetermined ||
        self.authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        self.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        // 从未决定、已授权
        // => 拒绝
        if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
            self.didDenyAuthorizationBlock == nil ?: self.didDenyAuthorizationBlock(status);
        }
    }
    if (self.authorizationStatus == kCLAuthorizationStatusRestricted ||
        self.authorizationStatus == kCLAuthorizationStatusDenied ||
        self.authorizationStatus == kCLAuthorizationStatusNotDetermined) {
        // 从拒绝、未决定
        // => 授权
        if (status == kCLAuthorizationStatusAuthorizedAlways ||
            status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            // 发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kYHAuthorizeGetLocationNotiKey object:@(status)];
        }
    }

    self.authorizationStatus = status;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (self.didGetLocationBlock) {
        self.didGetLocationBlock(locations.lastObject);
        // 一次性，防止定位结果多次返回
        _didGetLocationBlock = nil;
    }
    self.didGetLocationBlock == nil ?: self.didGetUpdatingLocationsBlock(locations);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位出错：%@", error.localizedDescription);
//    ShowFailedMsg(error.localizedDescription);
}


@end
