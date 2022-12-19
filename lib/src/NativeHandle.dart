import 'dart:async';
import 'package:flutter/services.dart';

class NativeHandle {
  static final NativeHandle _shared = NativeHandle._init();
  static get shared {
    return _shared;
  }

  factory NativeHandle() {
    return shared;
  }
  NativeHandle._init();

  static const MethodChannel _channel = MethodChannel("flutter.io.method");
  Future getdata(Map<String, dynamic> json) async {
    final dynamic data = await _channel.invokeMapMethod('getNativeData', json);
    return data;
  }
}
