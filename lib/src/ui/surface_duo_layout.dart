import 'package:flutter/material.dart';
import 'package:surface_duo/src/constants.dart';

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

    if (!isDuoSpannedSize) {
      return child;
    }

    return Row(
      children: <Widget>[
        SizedBox.fromSize(
          size: unspannedSize,
          child: child,
        ),
        const SizedBox(width: centerBarWidth),
        SizedBox.fromSize(
          size: unspannedSize,
          child: secondChild,
        ),
      ],
    );
  }
}
