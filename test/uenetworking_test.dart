import 'package:flutter_test/flutter_test.dart';
import 'package:uenetworking/uenetworking.dart';
import 'package:uenetworking/uenetworking_platform_interface.dart';
import 'package:uenetworking/uenetworking_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockUenetworkingPlatform
    with MockPlatformInterfaceMixin
    implements UenetworkingPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final UenetworkingPlatform initialPlatform = UenetworkingPlatform.instance;

  test('$MethodChannelUenetworking is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelUenetworking>());
  });

  test('getPlatformVersion', () async {
    Uenetworking uenetworkingPlugin = Uenetworking();
    MockUenetworkingPlatform fakePlatform = MockUenetworkingPlatform();
    UenetworkingPlatform.instance = fakePlatform;

    expect(await uenetworkingPlugin.getPlatformVersion(), '42');
  });
}
