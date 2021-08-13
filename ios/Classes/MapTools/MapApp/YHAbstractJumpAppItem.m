//
//  YHAbstractJumpAppItem.m
//  YHCommonUI
//
//  Created by Waynn on 2020/9/24.
//

#import "YHAbstractJumpAppItem.h"

@interface YHAbstractJumpAppItem()

@end

@implementation YHAbstractJumpAppItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        _name = @"未知App";
        _scheme = [NSURL new];
    }
    return self;
}

- (BOOL)canOpen {
    return [[UIApplication sharedApplication] canOpenURL:self.scheme];
}

- (void)openURL:(NSString *)urlString {
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSURL *url = [NSURL URLWithString:urlString];

    if (@available(iOS 10.0, *)) {
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:url options:@{} completionHandler:nil];
    } else {
        // Fallback on earlier versions
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end

/* =========================================== */
#pragma mark - 滴滴出行
/* =========================================== */

@implementation YHJumpDiDiAppItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"滴滴出行";
        self.scheme = [NSURL URLWithString:@"OneTravel://"];
    }
    return self;
}

- (void)jumpToAppBySlat:(CGFloat)slat
                   slon:(CGFloat)slon
                   dlat:(CGFloat)dlat
                   dlon:(CGFloat)dlon {

    //     NSString *urlString = @"OneTravel://dache/sendorder?slat=39.936625&slon=116.412893&dlat=39.889252&dlon=116.404269&source=demo";

    NSString *str = [NSString stringWithFormat:@"%@dache/sendorder?slat=%f&slon=%f&dlat=%f&dlon=%f",self.scheme.absoluteString, slat, slon, dlat, dlon];

    [self openURL:str];
}


@end
