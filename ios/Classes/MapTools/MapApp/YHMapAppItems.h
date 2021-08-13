//
//  YHMapAppItems.h
//  YHNurseSDK
//
//  Created by Waynn on 2020/9/7.
//

#import <Foundation/Foundation.h>
#import "YHLocationHelper.h"
#import "YHAbstractJumpAppItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHAbstractMapAppItem : YHAbstractJumpAppItem

/// 将要传入坐标的坐标系统
@property (nonatomic, assign) YHCoordinateSystem coordinateSystem;

/// 根据坐标系统处理过的坐（均转换为GCJ－02）
- (CLLocationCoordinate2D)processedCoordinate:(CLLocationCoordinate2D)coordinate;

/// 跳转到app导航，当前位置 => 目标位置
/// @param desCoordinate 目的地坐标
/// @param desName 目的地名
- (void)jumpToNavByDesCoordinate:(CLLocationCoordinate2D)desCoordinate
                         desName:(NSString * _Nullable)desName;


@end

/* 未实现功能：
 1. 地点标注
 2. 搜索查询
 3. 周边生活服务
 4. 公交&地铁线路查询
 ...
 */

/* =========================================== */
#pragma mark - 苹果地图
/* =========================================== */
/// 苹果地图
@interface YHAppleMapAppItem : YHAbstractMapAppItem

@end

/* =========================================== */
#pragma mark - 百度地图 baidumap://
/* =========================================== */
/// 百度地图
@interface YHBaiduMapAppItem : YHAbstractMapAppItem

@end

/* =========================================== */
#pragma mark - 高德地图 iosamap://
/* =========================================== */
/// 高德地图
@interface YHAmapMapAppItem : YHAbstractMapAppItem

@end

/* =========================================== */
#pragma mark - 腾讯地图 qqmap://
/* =========================================== */
/// 腾讯地图
@interface YHTencentMapAppItem : YHAbstractMapAppItem

@end

/* =========================================== */
#pragma mark - 谷歌地图 comgooglemaps://
/* =========================================== */
/// 谷歌地图
@interface YHGoogleMapAppItem : YHAbstractMapAppItem

@end

NS_ASSUME_NONNULL_END
