//
//  YHMapAppHelper.m
//  YHNurseSDK
//
//  Created by Waynn on 2020/9/7.
//

#import "YHMapAppHelper.h"

@implementation YHMapAppHelper

+ (NSArray<YHAbstractMapAppItem *> *)getAllMapItems {
    NSArray *allItems = @[YHAppleMapAppItem.new,
                          YHBaiduMapAppItem.new,
                          YHAmapMapAppItem.new,
                          YHTencentMapAppItem.new,
                          YHGoogleMapAppItem.new];

    return allItems;
}

+ (NSArray<YHAbstractMapAppItem *> *)getInstalledMapApps {
    NSMutableArray *maps = [NSMutableArray array];

    for (YHAbstractMapAppItem *item in [self getAllMapItems]) {
        if (item.canOpen) {
            [maps addObject:item];
        }
    }

    return maps;
}

+ (UIAlertController *)getInstalledMapAppsActionSheetControllerWithBlock:(void (^)(YHAbstractMapAppItem * _Nonnull item))selectedBlock {
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"选择地图App" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    for (YHAbstractMapAppItem *item in [self getInstalledMapApps]) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:item.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            selectedBlock(item);
        }];

        [ac addAction:action];
    }

    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:action];

    return ac;
}

@end
