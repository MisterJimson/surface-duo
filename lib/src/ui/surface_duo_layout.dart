import 'package:flutter/material.dart';
import 'package:surface_duo/src/ui/surface_duo_info.dart';

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
    return SurfaceDuoInfo(
      builder: (info) {
        if (!info.isSpanned) {
          return child;
        }
        return Row(
          children: <Widget>[
            Expanded(
              child: child,
            ),
            SizedBox(width: info.seemThickness),
            Expanded(
              child: secondChild,
            ),
          ],
        );
      },
    );
  }
}
