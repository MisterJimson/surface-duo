import 'dart:async';

import 'package:flutter/services.dart';

class SurfaceDuo {
  static const MethodChannel _channel = const MethodChannel('surface_duo');

  void test() async {
    final bool isDual = await _channel.invokeMethod('isDualScreenDevice');
    final bool isSpanned = await _channel.invokeMethod('isAppSpanned');
    final double hingeAngle = await _channel.invokeMethod('getHingeAngle');

    print('isDualScreenDevice : $isDual');
    print('isAppSpanned : $isSpanned');
    print('hingeAngle : $hingeAngle');
  }
}
