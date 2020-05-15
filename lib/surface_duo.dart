import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SurfaceDuo {
  //todo do we need unspanned?
  // Unspanned size
  // Height: 704.0
  // Width: 540.0

  //todo get at runtime? What benefits?
  // Spanned size
  // Height: 704.0
  // Width: 1113.6

  static const MethodChannel _channel = const MethodChannel('surface_duo');

  Future<bool> getIsDual() async {
    final isDual = await _channel.invokeMethod<bool>('isDualScreenDevice');
    return isDual;
  }

  Future<bool> getIsSpanned() async {
    final isAppSpanned = await _channel.invokeMethod<bool>('isAppSpanned');
    return isAppSpanned;
  }

  Future<double> getHingeAngle() async {
    final hingeAngle = await _channel.invokeMethod<double>('getHingeAngle');
    return hingeAngle;
  }

  Future<NonFunctionalBounds> getNonFunctionalBounds() async {
    final result =
        await _channel.invokeMethod<String>('getNonFunctionalBounds');
    if (result == null) {
      return null;
    } else {
      return NonFunctionalBounds.fromJson(jsonDecode(result));
    }
  }
}

class NonFunctionalBounds {
  double top;
  double bottom;
  double left;
  double right;

  NonFunctionalBounds({
    this.bottom,
    this.left,
    this.right,
    this.top,
  });

  factory NonFunctionalBounds.fromJson(Map<String, dynamic> json) =>
      NonFunctionalBounds(
        bottom: json["bottom"],
        left: json["left"],
        right: json["right"],
        top: json["top"],
      );

  Map<String, dynamic> toJson() => {
        "bottom": bottom,
        "left": left,
        "right": right,
        "top": top,
      };
}

const unspannedSize = Size(540.0, 704);
const spannedSize = Size(1113.6, 704);

class SurfaceDuoLayout extends StatelessWidget {
  final Widget child;
  final Widget secondChild;

  const SurfaceDuoLayout({Key key, this.child, this.secondChild})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    var isDuoSpannedSize = size == spannedSize;
    //var isDuoUnspannedSize = size == unspannedSize;

    if (!isDuoSpannedSize) {
      return child;
    }

    return Row(
      children: <Widget>[
        SizedBox.fromSize(
          size: unspannedSize,
          child: child,
        ),
        SizedBox(width: 33.6),
        SizedBox.fromSize(
          size: unspannedSize,
          child: secondChild,
        ),
      ],
    );
  }
}
