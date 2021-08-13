//
//  FlutterMethodCallAndResult.m
//  map_helper
//
//  Created by LiaoJiangtu on 2021/8/12.
//

#import "FlutterMethodCallAndResult.h"

@implementation FlutterMethodCallAndResult

/**
 * Creates a method callAndResult for invoking the specified call and result
 *
 * @param call the call.
 * @param result the result.
 */
+ (instancetype)methodCallWithMethodCall:(FlutterMethodCall*)call result:(FlutterResult _Nullable)result
{
    FlutterMethodCallAndResult * cr = [[FlutterMethodCallAndResult alloc] init];
    cr.method = call.method;
    cr.arguments = call.arguments;
    cr.result = result;
    return cr;
}

@end
