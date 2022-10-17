
import 'dart:async';

import 'package:flutter/services.dart';

class MapHelper {
  static const MethodChannel _channel =
      const MethodChannel('map_helper');

  static Future<String?> openMap(Address address) async {
    try{
      final String? success = await _channel.invokeMethod('openMap', address.toJson());
      return success;
    }catch(e){
      return "exp";
    }
  }

  static Future<bool?> startLocation(Function(Address address)? handler) async {
    try{
      _channel.setMethodCallHandler((call) => Future((){
        print('--native call-- {method:${call.method},arguments:${call.arguments}}');
        if(call.method == 'currentLoaction'){
          Address address = Address.fromMap(call.arguments);
          if(handler!=null){
            handler(address);
          }
        }
      }));
      final bool? success = await _channel.invokeMethod('startLocation');
      return success;
    }catch(e){
      return false;
    }
  }

  static Future<bool?> stopLocation() async {
    try{
      final bool? success = await _channel.invokeMethod('stopLocation');
      return success;
    }catch(e){
      return false;
    }
  }
}

class Address {
  String? address;
  String? lat;
  String? lng;

  Address({this.address,this.lat,this.lng});

  Address.fromMap(Map<String, dynamic> map) {
    this.address = map["address"]??'';
    this.lat = map["lat"].toString();
    this.lng = map["lng"].toString();
  }

  Map toJson() {
    Map map = new Map();
    map["address"] = this.address;
    map["lat"] = this.lat;
    map["lng"] = this.lng;
    return map;
  }

}