//
//  YHLocationHelper.h
//  YHCommonUI
//
//  Created by Waynn on 2020/9/10.
//
//  定位相关功能类

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define tLocationHelper [YHLocationHelper sharedHelper]

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    /// GCJ－02
    YHCoordinateSystem_GCJ,
    /// BD-09
    YHCoordinateSystem_BD,
    /// WGS－84
    YHCoordinateSystem_WGS,
} YHCoordinateSystem;

// app获得了定位权限时的通知（notDetermined/denied/restricted）=> (whenInUse/always)
static NSString * const kYHAuthorizeGetLocationNotiKey = @"kYHAuthorizeGetLocationNotiKey";

@interface YHLocationHelper : NSObject

+ (instancetype)sharedHelper;

/* =========================================== */
#pragma mark - 定位
/* =========================================== */

/// 定位权限状态
@property (nonatomic, assign) CLAuthorizationStatus authorizationStatus;

/// app请求授权被拒绝时的回调 notDetermined/whenInUse/always =>  denied
@property (nonatomic, copy) void(^didDenyAuthorizationBlock)(CLAuthorizationStatus status);

/// 设置回调得到的位置精度。默认 kCLLocationAccuracyBest
@property(nonatomic, assign) CLLocationAccuracy desiredAccuracy;

/// 获取一个定位信息
- (void)requestLocationWithBlock:(void (^)(CLLocation *location))block;

/* =========================================== */

/// 开始持续获取定位信息
- (void)startUpdatingLocation;

/// 持续得到定位信息的回调
@property (nonatomic, copy) void(^didGetUpdatingLocationsBlock)(NSArray<CLLocation *> *locations);

/// 停止持续获取定位信息
- (void)stopUpdatingLocation;

/* =========================================== */

/// 默认位置的坐标的坐标系为WGS－84
- (CLLocation *)currentLoaction;

/// 获取当前坐标
/// @param system 坐标系
- (CLLocationCoordinate2D)currentCoordinateBySystem:(YHCoordinateSystem)system;

/* =========================================== */
#pragma mark - 地址解析
/* =========================================== */

/// 地址解析 （地址信息 => 坐标）
/// @param addressString 地址字符串
/// @param region 区域（选填）
/// @param completionHandler 完成回调
- (void)geocodeAddressString:(NSString *)addressString inRegion:(nullable CLRegion *)region completionHandler:(CLGeocodeCompletionHandler)completionHandler;

/// 逆地址解析（坐标 => 地址信息）
/// @param location 位置
/// @param completionHandler 完成回调
- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(CLGeocodeCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
