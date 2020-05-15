import 'package:flutter/material.dart';
import 'package:surface_duo/surface_duo.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text('Example!'),
              onPressed: () {},
            ),
            RaisedButton(
              child: Text('Example!'),
              onPressed: () {},
            ),
            RaisedButton(
              child: Text('Example!'),
              onPressed: () {},
            ),
          ],
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
            RaisedButton(
              child: Text('Example!'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
