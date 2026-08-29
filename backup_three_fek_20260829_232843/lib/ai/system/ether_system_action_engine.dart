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

    if (lower.startsWith('open ')) {
      final target = text.substring(5).trim();

      if (target.startsWith('http://') ||
          target.startsWith('https://')) {
        try {
          await android.openUrl(target);
          return 'Opening $target.';
        } catch (e) {
          return 'I could not open $target: $e';
        }
      }

      return 'I understood that you want to open $target, but I do not know its URL yet.';
    }

    if (lower.startsWith('launch ')) {
      final target = text.substring(7).trim();

      return 'I understood that you want to launch $target, but app launching is not connected yet.';
    }

    return 'I understood this as a system action, but I do not have an executor for it yet.';
  }
}
