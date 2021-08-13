import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:map_helper/map_helper.dart';

void main() {
  const MethodChannel channel = MethodChannel('map_helper');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('openMap', () async {
    expect(await MapHelper.openMap, '42');
  });
}
