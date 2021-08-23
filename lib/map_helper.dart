
import 'dart:async';

import 'package:flutter/services.dart';

class MapHelper {
  static const MethodChannel _channel =
      const MethodChannel('map_helper');

  static Future<String?> openMap(String address) async {
    try{
      final String? success = await _channel.invokeMethod('openMap', address);
      return success;
    }catch(e){
      return "exp";
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