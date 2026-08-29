class EtherSystemActionEngine {
  Future<String> execute(String input) async {
    final text = input.trim();

    if (text.isEmpty) {
      return 'I need a system command.';
    }

    final lower = text.toLowerCase();

    if (lower.contains('booking.com')) {
      return 'SYSTEM ACTION READY: I can open Booking.com when Android system launching is connected.';
    }

    if (lower.startsWith('open ')) {
      final target = text.substring(5).trim();

      return 'SYSTEM ACTION READY: I can open $target when Android system launching is connected.';
    }

    if (lower.startsWith('launch ')) {
      final target = text.substring(7).trim();

      return 'SYSTEM ACTION READY: I can launch $target when Android system launching is connected.';
    }

    return 'I understood this as a system action, but I do not have an executor for it yet.';
  }
}
