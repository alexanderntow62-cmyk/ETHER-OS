import 'ether_android_bridge.dart';

class EtherSystemActionEngine {
  final EtherAndroidBridge android;

  EtherSystemActionEngine({EtherAndroidBridge? android})
      : android = android ?? EtherAndroidBridge();

  Future<String> execute(String input) async {
    final text = input.trim();

    if (text.isEmpty) {
      return 'I need a system command.';
    }

    final lower = text.toLowerCase();

    // Known website shortcut.
    if (lower.contains('booking.com')) {
      try {
        final opened =
            await android.openUrl('https://www.booking.com/');

        if (!opened) {
          return 'I could not open Booking.com.';
        }

        return 'Opening Booking.com.';
      } catch (e) {
        return 'I could not open Booking.com: $e';
      }
    }

    // Android Settings.
    if (lower == 'settings' ||
        lower == 'open settings' ||
        lower == 'start settings') {
      return _openSettings();
    }

    // Explicit URL.
    if (lower.startsWith('open ')) {
      final target = text.substring(5).trim();

      if (target.startsWith('http://') ||
          target.startsWith('https://')) {
        return _openUrl(target);
      }

      if (target.toLowerCase() == 'settings') {
        return _openSettings();
      }

      return _launchByName(target);
    }

    // Explicit launch command.
    if (lower.startsWith('launch ')) {
      final target = text.substring(7).trim();

      if (target.isEmpty) {
        return 'I need an app name to launch.';
      }

      // Preserve direct package-name support.
      if (target.contains('.')) {
        try {
          final launched = await android.launchApp(target);

          if (launched) {
            return 'Launched $target.';
          }
        } catch (_) {
          // Fall through to name resolution.
        }
      }

      return _launchByName(target);
    }

    // Start command.
    if (lower.startsWith('start ')) {
      final target = text.substring(6).trim();

      if (target.isEmpty) {
        return 'I need an app name to start.';
      }

      return _launchByName(target);
    }

    return 'I understood this as a system action, but I do not have an executor for it yet.';
  }

  Future<String> _openUrl(String url) async {
    try {
      final opened = await android.openUrl(url);

      if (!opened) {
        return 'I could not open $url.';
      }

      return 'Opening $url.';
    } catch (e) {
      return 'I could not open $url: $e';
    }
  }

  Future<String> _launchByName(String appName) async {
    try {
      final packageName = await android.resolveApp(appName);

      if (packageName == null || packageName.trim().isEmpty) {
        return 'I could not find an installed app named $appName.';
      }

      final launched = await android.launchApp(packageName);

      if (!launched) {
        return 'I found $appName, but Android could not launch it.';
      }

      return 'Opening $appName.';
    } catch (e) {
      return 'I could not launch $appName: $e';
    }
  }

  Future<String> _openSettings() async {
    try {
      final opened = await android.openSettings();

      if (!opened) {
        return 'I could not open Android Settings.';
      }

      return 'Opening Android Settings.';
    } catch (e) {
      return 'I could not open Android Settings: $e';
    }
  }
}
