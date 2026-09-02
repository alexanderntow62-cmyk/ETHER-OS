import '../google_integration_models.dart';

abstract class GmailService {
  Future<List<GmailMessage>> search(String query);

  Future<GmailMessage?> read(String messageId);

  Future<GmailDraft> createDraft(GmailDraft draft);

  /// Sending email is a consequential action.
  /// Implementations must enforce ETHER's approval boundary.
  Future<String> send(GmailDraft draft);
}
