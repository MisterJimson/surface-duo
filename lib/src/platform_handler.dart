import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:surface_duo/src/models.dart';

class SurfaceDuo {
  SurfaceDuo._();

  static const MethodChannel _channel = const MethodChannel('surface_duo');

  static Future<bool> getIsDual() async {
    if (!Platform.isAndroid) return false;
    final isDual = await _channel.invokeMethod<bool>('isDualScreenDevice');
    return isDual;
  }

  static Future<bool> getIsSpanned() async {
    if (!Platform.isAndroid) return false;
    final isAppSpanned = await _channel.invokeMethod<bool>('isAppSpanned');
    return isAppSpanned;
  }

  static Future<double> getHingeAngle() async {
    if (!Platform.isAndroid) return null;
    final hingeAngle = await _channel.invokeMethod<double>('getHingeAngle');
    return hingeAngle;
  }

  static Future<NonFunctionalBounds> getNonFunctionalBounds() async {
    if (!Platform.isAndroid) return null;
    final result =
        await _channel.invokeMethod<String>('getNonFunctionalBounds');
    if (result == null) {
      return null;
    } else {
      return NonFunctionalBounds.fromJson(jsonDecode(result));
    }
  }

  static Future<SurfaceDuoInfoModel> getInfoModel() async {
    if (!Platform.isAndroid) return null;
    final result = await _channel.invokeMethod<String>('getInfoModel');
    if (result == null) {
      return null;
    } else {
      return SurfaceDuoInfoModel.fromJson(jsonDecode(result));
    }
  }
}
