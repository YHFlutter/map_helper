//
//  FlutterMethodCallAndResult.h
//  map_helper
//
//  Created by LiaoJiangtu on 2021/8/12.
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlutterMethodCallAndResult : FlutterMethodCall

/**
 * Creates a method callAndResult for invoking the specified call and result
 *
 * @param call the call.
 * @param result the result.
 */
+ (instancetype)methodCallWithMethodCall:(FlutterMethodCall*)call result:(FlutterResult _Nullable)result;

/**
 * The method name.
 */
@property(nonatomic) NSString* method;

/**
 * The arguments.
 */
@property(nonatomic, nullable) id arguments;

/**
 * The result.
 */
@property(nonatomic, nullable) FlutterResult result;

@end

NS_ASSUME_NONNULL_END
