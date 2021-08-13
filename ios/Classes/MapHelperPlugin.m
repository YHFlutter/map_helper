#import "MapHelperPlugin.h"
#import "YHLocationHelper.h"
#import "YHMapAppHelper.h"
#import "FlutterMethodCallAndResult.h"


@interface MapHelperPlugin()

@property(nonatomic,strong)NSMutableDictionary *awaitFlutterCalls;

@end

@implementation MapHelperPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"map_helper"
            binaryMessenger:[registrar messenger]];
  MapHelperPlugin* instance = [[MapHelperPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}



- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
  if ([@"openMap" isEqualToString:call.method]) {
      
      if (call.arguments && [call.arguments isKindOfClass:[NSDictionary class]]) {
          
          NSDictionary *param = call.arguments;
          if ([param objectForKey:@"lat"] == nil) {
              result(@"fail, lat is null!");
          }else if ([param objectForKey:@"lng"] == nil) {
              result(@"fail, lng is null!");
          }
          CLLocationDegrees latitude = [[param objectForKey:@"lat"] doubleValue];
          CLLocationDegrees longitude = [[param objectForKey:@"lng"] doubleValue];
          CLLocationCoordinate2D desCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
          NSString *address = [param objectForKey:@"address"]?:@"";
          
          UIAlertController *alert = [YHMapAppHelper getInstalledMapAppsActionSheetControllerWithBlock:^(YHAbstractMapAppItem * _Nonnull item) {
              if (item.canOpen) {
                  [item jumpToNavByDesCoordinate:desCoordinate desName:address];
              }
          }];
          UIViewController *rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
          if (rootVC) {
              [rootVC presentViewController:alert animated:YES completion:^{
                  result(@"success");
              }];
          }else{
              result(@"fail");
          }
      }
      else{
          result(@"fail, arguments is null!");
      }
  } else if ([@"locationCoordinate" isEqualToString:call.method]) {
      
      //缓存参数
      FlutterMethodCallAndResult *backCR = [FlutterMethodCallAndResult methodCallWithMethodCall:call result:result];
      [self.awaitFlutterCalls setObject:backCR forKey:call.method];
      
      //当前坐标
      if ([YHLocationHelper sharedHelper].authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
          [YHLocationHelper sharedHelper].authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
          if ([YHLocationHelper sharedHelper].currentLoaction) {
              return [self getLocationCoordinateWhenAuth];
          }
      }
      [[YHLocationHelper sharedHelper] startUpdatingLocation];
      
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeAuthorizationStatus) name:kYHAuthorizeGetLocationNotiKey object:nil];
      
  } else {
      result(FlutterMethodNotImplemented);
  }
}


/// 获取当前坐标
- (void)getLocationCoordinateWhenAuth{
    
    FlutterMethodCallAndResult *call = [self.awaitFlutterCalls objectForKey:@"locationCoordinate"];
    if (call) {
        YHCoordinateSystem type = YHCoordinateSystem_GCJ;
        if (call.arguments && [call.arguments isKindOfClass:[NSString class]]) {
            
            if ([@"BD" isEqualToString:call.arguments]) {
                type = YHCoordinateSystem_BD;
            }else if ([@"WGS" isEqualToString:call.arguments]) {
                type = YHCoordinateSystem_BD;
            }
        }
        CLLocationCoordinate2D coordinate= [[YHLocationHelper sharedHelper] currentCoordinateBySystem:type];
        NSString *coordinateJsonString = [NSString stringWithFormat:@"{'lat':'%f','lng':'%f'}",coordinate.latitude,coordinate.longitude];
        call.result(coordinateJsonString);
        
        //处理完成，清除缓存
        [self.awaitFlutterCalls removeObjectForKey:@"locationCoordinate"];
    }
}

- (void)didChangeAuthorizationStatus{
    [[YHLocationHelper sharedHelper] stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kYHAuthorizeGetLocationNotiKey object:nil];
    
    if ([YHLocationHelper sharedHelper].authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        [YHLocationHelper sharedHelper].authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        if ([YHLocationHelper sharedHelper].currentLoaction) {
            return [self getLocationCoordinateWhenAuth];
        }
    }
    //获取定位失败
    FlutterMethodCallAndResult *call = [self.awaitFlutterCalls objectForKey:@"locationCoordinate"];
    if (call) {
        call.result(@"{'lat':'-1','lng':'-1'}");
        //处理完成，清除缓存
        [self.awaitFlutterCalls removeObjectForKey:@"locationCoordinate"];
    }
}

-(NSMutableDictionary *)awaitFlutterCalls{
    
    if (!_awaitFlutterCalls) {
        _awaitFlutterCalls = [NSMutableDictionary dictionary];
    }
    return _awaitFlutterCalls;
}


@end
