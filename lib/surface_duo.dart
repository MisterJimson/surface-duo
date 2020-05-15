import 'dart:async';

import 'package:flutter/services.dart';

class SurfaceDuo {
  static const MethodChannel _channel =
      const MethodChannel('surface_duo');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
