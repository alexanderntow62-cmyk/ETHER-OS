import 'package:flutter/services.dart';

class EtherAndroidBridge {
  static const MethodChannel _channel = MethodChannel('ether/system');

  Future<bool> openUrl(String url) async {
    final result = await _channel.invokeMethod<bool>(
      'openUrl',
      <String, dynamic>{
        'url': url,
      },
    );

    return result ?? false;
  }

  Future<bool> launchApp(String appName) async {
    final result = await _channel.invokeMethod<bool>(
      'launchApp',
      <String, dynamic>{
        'appName': appName,
      },
    );

    return result ?? false;
  }
}
