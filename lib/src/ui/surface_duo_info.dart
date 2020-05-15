import 'package:flutter/widgets.dart';
import 'package:surface_duo/src/models.dart';
import 'package:surface_duo/src/platform_handler.dart';

class SurfaceDuoInfo extends StatefulWidget {
  final Widget Function(SurfaceDuoInfoModel info) builder;

  const SurfaceDuoInfo({
    @required this.builder,
  })  : assert(builder != null),
        super(key: const PageStorageKey('SurfaceDuoInfo'));

  @override
  _SurfaceDuoInfoState createState() => _SurfaceDuoInfoState();
}

class _SurfaceDuoInfoState extends State<SurfaceDuoInfo>
    with WidgetsBindingObserver {
  SurfaceDuoInfoModel info;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    info =
        (PageStorage.of(context).readState(context) as SurfaceDuoInfoModel) ??
            SurfaceDuoInfoModel.unknown();
    updateInfo();
  }

  @override
  void didChangeMetrics() {
    updateInfo();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(info);
  }

  Future updateInfo() async {
    if (mounted) {
      var _info = await SurfaceDuo.getInfoModel();
      PageStorage.of(context).writeState(context, _info);
      setState(() {
        info = _info;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
