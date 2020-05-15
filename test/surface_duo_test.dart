import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surface_duo/surface_duo.dart';

void main() {
  const MethodChannel channel = MethodChannel('surface_duo');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await SurfaceDuo.platformVersion, '42');
  });
}
