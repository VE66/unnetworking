import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'uenetworking_method_channel.dart';

abstract class UenetworkingPlatform extends PlatformInterface {
  /// Constructs a UenetworkingPlatform.
  UenetworkingPlatform() : super(token: _token);

  static final Object _token = Object();

  static UenetworkingPlatform _instance = MethodChannelUenetworking();

  /// The default instance of [UenetworkingPlatform] to use.
  ///
  /// Defaults to [MethodChannelUenetworking].
  static UenetworkingPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [UenetworkingPlatform] when
  /// they register themselves.
  static set instance(UenetworkingPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
