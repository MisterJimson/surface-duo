import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
    if (!Platform.isAndroid) return false;
    final isDual = await _channel.invokeMethod<bool>('isDualScreenDevice');
    return isDual;
  }

  Future<bool> getIsSpanned() async {
    if (!Platform.isAndroid) return false;
    final isAppSpanned = await _channel.invokeMethod<bool>('isAppSpanned');
    return isAppSpanned;
  }

  Future<double> getHingeAngle() async {
    if (!Platform.isAndroid) return null;
    final hingeAngle = await _channel.invokeMethod<double>('getHingeAngle');
    return hingeAngle;
  }

  Future<NonFunctionalBounds> getNonFunctionalBounds() async {
    if (!Platform.isAndroid) return null;
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
  final double top;
  final double bottom;
  final double left;
  final double right;

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

/// Currently supports Two Page layout
///
/// https://docs.microsoft.com/en-us/dual-screen/introduction#dual-screen-app-patterns
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
        const SizedBox(width: 33.6),
        SizedBox.fromSize(
          size: unspannedSize,
          child: secondChild,
        ),
      ],
    );
  }
}

class SurfaceDuoInfo extends StatefulWidget {
  final Widget Function(
    bool isDualScreenDevice,
    bool isSpanned,
    double hingeAngle,
  ) builder;

  const SurfaceDuoInfo({
    @required this.builder,
  })  : assert(builder != null),
        super(key: const PageStorageKey('SurfaceDuoInfo'));

  @override
  _SurfaceDuoInfoState createState() => _SurfaceDuoInfoState();
}

class _SurfaceDuoInfoState extends State<SurfaceDuoInfo>
    with WidgetsBindingObserver {
  bool isDualScreenDevice;
  bool isSpanned;
  double hingeAngle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    var info =
        PageStorage.of(context).readState(context) as _SurfaceDuoInfoCache;
    isDualScreenDevice = info?.isDualScreenDevice;
    isSpanned = info?.isSpanned;
    hingeAngle = info?.hingeAngle;
    getData();
  }

  @override
  void didChangeMetrics() {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(isDualScreenDevice, isSpanned, hingeAngle);
  }

  Future getData() async {
    final duo = SurfaceDuo();

    isDualScreenDevice ??= await duo.getIsDual();

    final _isSpanned = await duo.getIsSpanned();
    final _hingeAngle = await duo.getHingeAngle();

    if (mounted) {
      PageStorage.of(context).writeState(
        context,
        _SurfaceDuoInfoCache(
          isDualScreenDevice: isDualScreenDevice,
          isSpanned: isSpanned,
          hingeAngle: hingeAngle,
        ),
      );
      setState(() {
        isSpanned = _isSpanned;
        hingeAngle = _hingeAngle;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

class _SurfaceDuoInfoCache {
  final bool isDualScreenDevice;
  final bool isSpanned;
  final double hingeAngle;

  _SurfaceDuoInfoCache({
    this.isDualScreenDevice,
    this.isSpanned,
    this.hingeAngle,
  });
}
