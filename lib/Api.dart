// ignore: file_names
import 'dart:async';
// import 'dart:ffi';
import 'package:flutter/services.dart';
import 'NativeHandle.dart';
import 'Networking.dart';

typedef ProgressCallback = void Function(int, int);

class Api {
  static Future<dynamic> getNativeData(Map<String, dynamic> json) async {
    final dynamic data = await NativeHandle().getdata(json);
    return data;
  }

  static final Api _shared = Api._init();
  static get shared {
    return _shared;
  }

  factory Api() {
    return shared;
  }

  // ignore: non_constant_identifier_names
  var k_accessId = "";
  var visitorId = "";
  var account = "";
  Api._init();

  static Future<dynamic> get(
      {required String url,
      NetPath path = NetPath.none,
      required Map<String, dynamic> json,
      required String accessId}) async {
    final dynamic data = await Networking.shared.request(
      url: url,
      method: NetMethod.get,
      path: path,
      params: json,
      accessId: accessId,
    );
    return data;
  }

  static Future<dynamic> post(
      {required String url,
      NetPath path = NetPath.none,
      required Map<String, dynamic> json,
      required String accessId}) async {
    final dynamic data = await Networking.shared.request(
        url: url,
        method: NetMethod.post,
        path: path,
        params: json,
        accessId: accessId,
        header: {
          "visitorId": Api.shared.visitorId,
          "account": Api.shared.account
        });
    return data;
  }

  static Future<dynamic> down(String url, String savePath,
      {ProgressCallback? progress}) async {
    final dynamic data =
        await Networking.shared.downData(url, savePath, progress: progress);
    return data;
  }

  static Future<dynamic> apiGetTag(String url, String tagId) async {
    Map<String, dynamic> params = {};
    params['tagId'] = tagId;
    params['account'] = Api.shared.account;
    params['accessId'] = Api.shared.k_accessId;
    params['visitorId'] = Api.shared..visitorId;
    final dynamic data = await Networking.shared.request(
      url: url,
      params: params,
      path: NetPath.getTag,
      accessId: Api.shared.k_accessId,
    );
    return data;
  }
}
