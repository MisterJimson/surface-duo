import 'dart:async';

import 'package:flutter/services.dart';

class SurfaceDuo {
  // Unspanned size
  // Height: 704.0
  // Width: 540.0

  // Spanned size
  // Height: 704.0
  // Width: 1113.6

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
