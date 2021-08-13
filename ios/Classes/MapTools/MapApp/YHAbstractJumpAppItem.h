//
//  YHAbstractJumpAppItem.h
//  YHCommonUI
//
//  Created by Waynn on 2020/9/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHAbstractJumpAppItem : NSObject

@property (nonatomic, copy) NSString *name;
/// [NSURL URLWithString:@"xxx://"];
@property (nonatomic, copy) NSURL *scheme;

- (BOOL)canOpen;

- (void)openURL:(NSString *)urlString;

@end

/* =========================================== */
#pragma mark - 滴滴出行 OneTravel://
/* =========================================== */

@interface YHJumpDiDiAppItem : YHAbstractJumpAppItem

/// 跳转到滴滴出行
/// @param slat 起始纬度
/// @param slon 起始经度
/// @param dlat 终点纬度
/// @param dlon 终点经度
- (void)jumpToAppBySlat:(CGFloat)slat
                   slon:(CGFloat)slon
                   dlat:(CGFloat)dlat
                   dlon:(CGFloat)dlon;

@end

NS_ASSUME_NONNULL_END
