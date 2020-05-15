import 'package:flutter/material.dart';
import 'package:surface_duo/surface_duo.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SurfaceDuoLayout(
      child: _buildMainPage(),
      secondChild: _buildSecondPage(),
    );
  }

  Widget _buildMainPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Center(
        child: SurfaceDuoInfo(
          builder: (isDualScreenDevice, isSpanned, hingeAngle) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('This page always displays!'),
                Text('isDualScreenDevice: $isDualScreenDevice'),
                Text('isAppSpanned: $isSpanned'),
                Text('hingeAngle: $hingeAngle'),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSecondPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      backgroundColor: Colors.tealAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('This page only shows when spanned on 2 screens!'),
          ],
        ),
      ),
    );
  }
}
