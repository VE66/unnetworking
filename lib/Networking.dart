import 'dart:isolate';

import 'package:dio/dio.dart';
import 'dart:convert';

enum NetPath {
  cancelQueue('/im-sdk/action/sdkChat/cancelQueue'),
  typeNotice('/im-sdk/action/sdkChat/typeNotice'),
  feedback('/im-sdk/action/robot/feedback'),
  sdkAccessId('/im-web-config/sdkAccessId'),
  socketAddress('/im-sdk/action/sdkChat/socketAddress'),
  emojiConfig('/im-sdk/action/sdkChat/getEmojiConfig'),
  getMsg('/im-sdk/action/sdkChat/getMsg'),
  getListMsg('/im-sdk/action/sdkChat/getListMsg'),
  newMsg('/im-sdk/action/sdkChat/newMsg'),
  getToken('/im-sdk/action/qiniu/getToken'),
  xbotFormSubmit('/xbotFormSubmit'),
  newSession('/im-sdk/action/sdkChat/newSession'),
  getSessionId('/im-sdk/action/sdkChat/getSessionId'),
  querySatisfaction('/im-sdk/action/sdkChat/querySatisfactionTmpById'),
  checkCSRStatus('/im-sdk/action/sdkChat/checkCSRStatus'),
  sendCSRMsg('/im-sdk/action/sdkChat/sendCSRMsg'),
  getTag('/im-sdk/action/sdkChat/getTag'),
  inputSuggest('/im-sdk/action/robot/inputSuggest'),
  convertManual('/im-sdk/action/robot/convertManual'),
  finsh('/im-sdk/action/sdkChat/visitor/finish'),
  dealImMsg('/im-sdk/action/sdkChat/dealImMsg'),
  none('');

  final String value;
  const NetPath(this.value);
}

enum NetMethod {
  get('GET'),
  post("POST"),
  put('PUT');

  final String value;
  const NetMethod(this.value);
}

class NetBody {
  NetMethod method;
  NetPath path;
  Map<String, dynamic> params;
  Options options;
  SendPort port;
  NetBody(this.method, this.path, this.params, this.options, this.port);
}

class Networking {
  static final Networking _shared = Networking._init();
  static Networking get shared {
    return _shared;
  }

  factory Networking() {
    return shared;
  }

  setupDio(String url) {
    BaseOptions options =
        BaseOptions(baseUrl: url, responseType: ResponseType.json);
    _dio = Dio(options);
  }

  late Dio _dio;
  Networking._init();

  Future<Response> downData(String url, String savePath,
      {ProgressCallback? progress}) async {
    final respone = await _dio.download(
      url,
      savePath,
      onReceiveProgress: progress,
    );
    return respone;
  }

  Future<dynamic> request(
      {required String url,
      NetMethod method = NetMethod.post,
      NetPath path = NetPath.none,
      required Map<String, dynamic> params,
      Map<String, dynamic>? header,
      required String accessId}) async {
    setupDio(url);
    var options =
        Options(method: method.value, contentType: 'application/json');
    options.headers ??= {};
    options.headers!['accessId'] = accessId;
    if (path != NetPath.socketAddress && header != null) {
      header.forEach((key, value) {
        options.headers![key] = value;
      });
      // if (UserSetting.shared.sessionInfo.visitorId.isNotEmpty) {
      //   options.headers!['visitorId'] =
      //       UserSetting.shared.sessionInfo.visitorId;
      // }
      // if (UserSetting.shared.account.isNotEmpty) {
      //   options.headers!['account'] = UserSetting.shared.account;
      // }
    }
    options.headers!['lang'] = 'zh_CN';

    try {
      ReceivePort receivePort = ReceivePort();
      Isolate isolate = await Isolate.spawn(sendRequest,
          NetBody(method, path, params, options, receivePort.sendPort));

      var result = await receivePort.first;
      receivePort.close();
      isolate.kill();
      return result;
    } on DioError catch (error) {
      print('error = $error');
      return {};
    }
  }

  void sendRequest(NetBody data) async {
    String json = jsonEncode(data.params);

    Response result =
        await _dio.request(data.path.value, data: json, options: data.options);
    data.port.send(result.data);
    // Isolate.exit(data.port);
  }
}
