import 'ether_android_bridge.dart';

class EtherSystemActionEngine {
  final EtherAndroidBridge android;

  EtherSystemActionEngine({
    EtherAndroidBridge? android,
  }) : android = android ?? EtherAndroidBridge();

  Future<String> execute(String input) async {
    final text = input.trim();

    if (text.isEmpty) {
      return 'I need a system command.';
    }

    final lower = text.toLowerCase();

    if (lower.contains('booking.com')) {
      try {
        await android.openUrl('https://www.booking.com/');
        return 'Opening Booking.com.';
      } catch (e) {
        return 'I could not open Booking.com: $e';
      }
    }

    if (lower.startsWith('launch ')) {
      final target = text.substring(7).trim();

      if (target.isEmpty) {
        return 'I need an app name to launch.';
      }

      try {
        final opened = await android.launchApp(target);

        if (opened) {
          return 'Opening $target.';
        }

        return 'I could not find an installed app named $target.';
      } catch (e) {
        return 'I could not launch $target: $e';
      }
    }

    if (lower.startsWith('open ')) {
      final target = text.substring(5).trim();

      if (target.isEmpty) {
        return 'I need an app or URL to open.';
      }

      if (target.startsWith('http://') ||
          target.startsWith('https://')) {
        try {
          await android.openUrl(target);
          return 'Opening $target.';
        } catch (e) {
          return 'I could not open $target: $e';
        }
      }

      try {
        final opened = await android.launchApp(target);

        if (opened) {
          return 'Opening $target.';
        }

        return 'I could not find an installed app named $target.';
      } catch (e) {
        return 'I could not open $target: $e';
      }
    }

    return 'I understood this as a system action, but I do not have an executor for it yet.';
  }
}
