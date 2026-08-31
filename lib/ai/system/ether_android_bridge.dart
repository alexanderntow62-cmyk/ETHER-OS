import 'package:flutter/services.dart';

class EtherAndroidBridge {
  static const MethodChannel _channel = MethodChannel('ether/system');

  Future<bool> openUrl(String url) async {
    final result = await _channel.invokeMethod<bool>(
      'openUrl',
      <String, dynamic>{'url': url},
    );

    return result ?? false;
  }

  Future<bool> launchApp(String packageName) async {
    final result = await _channel.invokeMethod<bool>(
      'launchApp',
      <String, dynamic>{'packageName': packageName},
    );

    return result ?? false;
  }

  Future<bool> isAppInstalled(String packageName) async {
    final result = await _channel.invokeMethod<bool>(
      'isAppInstalled',
      <String, dynamic>{'packageName': packageName},
    );

    return result ?? false;
  }

  Future<bool> openSettings() async {
    final result = await _channel.invokeMethod<bool>(
      'openSettings',
    );

    return result ?? false;
  }

  Future<String?> resolveApp(String appName) async {
    final result = await _channel.invokeMethod<String?>(
      'resolveApp',
      <String, dynamic>{'appName': appName},
    );

    return result;
  }

  Future<bool> launchAppByName(String appName) async {
    final result = await _channel.invokeMethod<bool>(
      'launchAppByName',
      <String, dynamic>{'appName': appName},
    );

    return result ?? false;
  }
}
