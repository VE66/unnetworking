import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'uenetworking_platform_interface.dart';

/// An implementation of [UenetworkingPlatform] that uses method channels.
class MethodChannelUenetworking extends UenetworkingPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('uenetworking');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
