import 'package:flutter/widgets.dart';
import 'package:surface_duo/src/platform_handler.dart';

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
    isDualScreenDevice ??= await SurfaceDuo.getIsDual();

    final _isSpanned = await SurfaceDuo.getIsSpanned();
    final _hingeAngle = await SurfaceDuo.getHingeAngle();

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
