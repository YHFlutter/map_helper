//
//  YHMapAppHelper.h
//  YHNurseSDK
//
//  Created by Waynn on 2020/9/7.
//

#import <Foundation/Foundation.h>
#import "YHMapAppItems.h"

/*
 复制下面代码，粘贴到主工程info.plist中
 (右键 -> Open As -> Source Code)
 百度、高德、腾讯、谷歌 地图

 <key>LSApplicationQueriesSchemes</key>
 <array>
 <string>baidumap</string>
 <string>iosamap</string>
 <string>qqmap</string>
 <string>comgooglemaps</string>
 </array>

 */

NS_ASSUME_NONNULL_BEGIN

@interface YHMapAppHelper : NSObject

/// 获取支持的全部地图AppItems
+ (NSArray<YHAbstractMapAppItem *> *)getAllMapItems;

/// 获取当前手机安装的地图AppItems，必有苹果地图
+ (NSArray<YHAbstractMapAppItem *> *)getInstalledMapApps;

/// 获取当前手机安装的地图的选择菜单 （self present...）
/// @param selectedBlock 选中回调
+ (UIAlertController *)getInstalledMapAppsActionSheetControllerWithBlock:(void (^)(YHAbstractMapAppItem *item))selectedBlock;

@end

NS_ASSUME_NONNULL_END
