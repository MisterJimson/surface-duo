import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Test'),
          onPressed: () {
            SurfaceDuo().test();
            var size = MediaQuery.of(context).size;
            print('Height: ${size.height}');
            print('Width: ${size.width}');
          },
        ),
      ),
    );
  }
}
