//
//  YHMapAppItems.m
//  YHNurseSDK
//
//  Created by Waynn on 2020/9/7.
//

#import "YHMapAppItems.h"
#import <MapKit/MapKit.h>
#import "YHLocationConverter.h"

@implementation YHAbstractMapAppItem

- (void)jumpToNavByDesCoordinate:(CLLocationCoordinate2D)desCoordinate
                         desName:(NSString * _Nullable)desName {
    // 子类实现
}

- (CLLocationCoordinate2D)processedCoordinate:(CLLocationCoordinate2D)coordinate{
    switch (self.coordinateSystem) {
        case YHCoordinateSystem_GCJ:
            return coordinate;
        case YHCoordinateSystem_BD:
            return [YHLocationConverter bd09ToGcj02:coordinate];
        case YHCoordinateSystem_WGS:
            return [YHLocationConverter wgs84ToGcj02:coordinate];
        default:
            return coordinate;
    }
}

@end

/* =========================================== */
#pragma mark - 苹果地图
/* =========================================== */

@implementation YHAppleMapAppItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"苹果地图";
        self.scheme = [NSURL URLWithString:@"map://"];
    }
    return self;
}

- (BOOL)canOpen {
    return true;
}

- (void)jumpToNavByDesCoordinate:(CLLocationCoordinate2D)desCoordinate
                         desName:(NSString *)desName {

    desCoordinate = [self processedCoordinate:desCoordinate];

    MKMapItem *curLocation = [MKMapItem mapItemForCurrentLocation];

    MKMapItem *desLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:desCoordinate addressDictionary:nil]];
    desLocation.name = desName;

    [MKMapItem openMapsWithItems:@[curLocation, desLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: @YES}];
}

@end

/* =========================================== */
#pragma mark - 百度地图
/* =========================================== */

@implementation YHBaiduMapAppItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"百度地图";;
        self.scheme = [NSURL URLWithString:@"baidumap://"];
    }
    return self;
}

- (void)jumpToNavByDesCoordinate:(CLLocationCoordinate2D)desCoordinate
                         desName:(NSString *)desName {

    desCoordinate = [self processedCoordinate:desCoordinate];

    // baidumap://map/direction?origin=34.264642646862,108.95108518068&destination=40.007623,116.360582&coord_type=bd09ll&mode=driving&src=ios.baidu.openAPIdemo

    NSString *str;
    if (desName == nil || [@"" isEqualToString:desName]) {
        str = [NSString stringWithFormat:@"%@map/direction?origin={{我的位置}}&destination=%f,%f&coord_type=gcj02&mode=driving",self.scheme.absoluteString, desCoordinate.latitude, desCoordinate.longitude];
    } else {
        str = [NSString stringWithFormat:@"%@map/direction?origin={{我的位置}}&destination=name:%@|latlng:%f,%f&coord_type=gcj02&mode=driving",self.scheme.absoluteString, desName, desCoordinate.latitude, desCoordinate.longitude];
    }

    [self openURL:str];
}

@end

/* =========================================== */
#pragma mark - 高德地图
/* =========================================== */

@implementation YHAmapMapAppItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"高德地图";
        self.scheme = [NSURL URLWithString:@"iosamap://"];
    }
    return self;
}

- (void)jumpToNavByDesCoordinate:(CLLocationCoordinate2D)desCoordinate
                         desName:(NSString *)desName {

    desCoordinate = [self processedCoordinate:desCoordinate];

    // iosamap://path?sourceApplication=applicationName&sid=&slat=39.92848272&slon=116.39560823&sname=A&did=&dlat=39.98848272&dlon=116.47560823&dname=B&dev=0&t=0

    NSString *str;
    if (desName == nil || [@"" isEqualToString:desName]) {
        str = [NSString stringWithFormat:@"iosamap://path?sname=我的位置&dlat=%f&dlon=%f&dev=0&t=0", desCoordinate.latitude, desCoordinate.longitude];
    } else {
        str = [NSString stringWithFormat:@"iosamap://path?sname=我的位置&dlat=%f&dlon=%f&dname=%@&dev=0&t=0", desCoordinate.latitude, desCoordinate.longitude, desName];
    }

    [self openURL:str];
}

@end

/* =========================================== */
#pragma mark - 腾讯地图
/* =========================================== */
// https://lbs.qq.com/webApi/uriV1/uriGuide/uriMobileRoute
@implementation YHTencentMapAppItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"腾讯地图";
        self.scheme = [NSURL URLWithString:@"qqmap://"];
    }
    return self;
}

- (void)jumpToNavByDesCoordinate:(CLLocationCoordinate2D)desCoordinate
                         desName:(NSString *)desName {

    desCoordinate = [self processedCoordinate:desCoordinate];

    // qqmap://map/routeplan?type=drive&from=清华&fromcoord=39.994745,116.247282&to=怡和世家&tocoord=39.867192,116.493187&referer=OB4BZ-D4W3U-B7VVO-4PJWW-6TKDJ-WPB77

    NSString *str;
    if (desName == nil || [@"" isEqualToString:desName]) {
        str = [NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&from=我的位置&tocoord=%f,%f&policy=1", desCoordinate.latitude, desCoordinate.longitude];
    } else {
        str = [NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&from=我的位置&to=%@&tocoord=%f,%f&policy=1", desName, desCoordinate.latitude, desCoordinate.longitude];
    }

    [self openURL:str];
}

@end

/* =========================================== */
#pragma mark - 谷歌地图
/* =========================================== */
// https://developers.google.com/maps/documentation/urls/ios-urlscheme#objective-c
@implementation YHGoogleMapAppItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"谷歌地图";
        self.scheme = [NSURL URLWithString:@"comgooglemaps://"];
    }
    return self;
}

- (void)jumpToNavByDesCoordinate:(CLLocationCoordinate2D)desCoordinate
                         desName:(NSString *)desName {

    desCoordinate = [self processedCoordinate:desCoordinate];

    // comgooglemaps://?saddr=2025+Garcia+Ave,+Mountain+View,+CA,+USA&daddr=Google,+1600+Amphitheatre+Parkway,+Mountain+View,+CA,+United+States&center=37.423725,-122.0877&directionsmode=walking&zoom=17

    NSString *str;
    if (desName == nil || [@"" isEqualToString:desName]) {
        str = [NSString stringWithFormat:@"comgooglemaps://?daddr=%f,%f&directionsmode=driving", desCoordinate.latitude, desCoordinate.longitude];
    } else {
        str = [NSString stringWithFormat:@"comgooglemaps://?daddr=%@&center=%f,%f&directionsmode=driving", desName, desCoordinate.latitude, desCoordinate.longitude];
    }

    [self openURL:str];
}

@end
