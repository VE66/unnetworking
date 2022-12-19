import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uenetworking/uenetworking_method_channel.dart';

void main() {
  MethodChannelUenetworking platform = MethodChannelUenetworking();
  const MethodChannel channel = MethodChannel('uenetworking');

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
    expect(await platform.getPlatformVersion(), '42');
  });
}
