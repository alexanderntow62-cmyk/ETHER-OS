import 'gmail_service.dart';
import '../google_integration_models.dart';
import '../auth/google_authorized_client.dart';
import 'gmail_http_client.dart';

/// Concrete Gmail integration for ETHER-OS.
///
/// Read operations may be performed autonomously.
/// Sending email remains a consequential action and must be
/// approved by the ETHER action/approval layer before execution.
class GoogleGmailService implements GmailService {
  final GmailHttpClient client;
  final GoogleAuthorizedClient authorizedClient;

  GoogleGmailService({required this.client, required this.authorizedClient});

  @override
  Future<List<GmailMessage>> search(String query) async {
    final response = await client.getJson(
      '/gmail/v1/users/me/messages',
      queryParameters: {'q': query},
    );

    final messages = response['messages'];

    if (messages is! List) {
      return const <GmailMessage>[];
    }

    return messages
        .whereType<Map<String, dynamic>>()
        .map(
          (message) => GmailMessage(
            id: message['id']?.toString() ?? '',
            threadId: message['threadId']?.toString() ?? '',
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<GmailMessage?> read(String messageId) async {
    if (messageId.trim().isEmpty) {
      return null;
    }

    final response = await client.getJson(
      '/gmail/v1/users/me/messages/$messageId',
      queryParameters: {'format': 'full'},
    );

    final payload = response['payload'];

    return GmailMessage(
      id: response['id']?.toString() ?? messageId,
      threadId: response['threadId']?.toString() ?? '',
      from: _header(payload, 'From'),
      to: _header(payload, 'To'),
      subject: _header(payload, 'Subject'),
      body: _extractBody(payload),
      receivedAt: _receivedAt(response['internalDate']),
      isRead: _isRead(response),
    );
  }

  @override
  Future<GmailDraft> createDraft(GmailDraft draft) async {
    final rawMessage = _encodeMessage(draft);

    await client.postJson('/gmail/v1/users/me/drafts', {
      'message': {'raw': rawMessage},
    });

    return draft;
  }

  @override
  Future<String> send(GmailDraft draft) async {
    final rawMessage = _encodeMessage(draft);

    final response = await client.postJson('/gmail/v1/users/me/messages/send', {
      'raw': rawMessage,
    });

    final messageId = response['id']?.toString();

    if (messageId == null || messageId.isEmpty) {
      throw const FormatException(
        'Gmail send response did not contain a message id.',
      );
    }

    return messageId;
  }

  String _header(dynamic payload, String name) {
    if (payload is! Map<String, dynamic>) {
      return '';
    }

    final headers = payload['headers'];

    if (headers is! List) {
      return '';
    }

    for (final header in headers) {
      if (header is Map<String, dynamic> &&
          header['name']?.toString().toLowerCase() == name.toLowerCase()) {
        return header['value']?.toString() ?? '';
      }
    }

    return '';
  }

  String _extractBody(dynamic payload) {
    if (payload is! Map<String, dynamic>) {
      return '';
    }

    final body = payload['body'];

    if (body is Map<String, dynamic>) {
      final data = body['data'];

      if (data is String && data.isNotEmpty) {
        return data;
      }
    }

    final parts = payload['parts'];

    if (parts is List) {
      for (final part in parts) {
        final result = _extractBody(part);

        if (result.isNotEmpty) {
          return result;
        }
      }
    }

    return '';
  }

  DateTime? _receivedAt(dynamic value) {
    final milliseconds = int.tryParse(value?.toString() ?? '');

    if (milliseconds == null) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);
  }

  bool _isRead(Map<String, dynamic> response) {
    final labelIds = response['labelIds'];

    if (labelIds is! List) {
      return false;
    }

    return !labelIds.map((label) => label.toString()).contains('UNREAD');
  }

  String _encodeMessage(GmailDraft draft) {
    final headers = <String>[
      'To: ${draft.to}',
      if (draft.cc.isNotEmpty) 'Cc: ${draft.cc.join(', ')}',
      if (draft.bcc.isNotEmpty) 'Bcc: ${draft.bcc.join(', ')}',
      'Subject: ${draft.subject}',
      'Content-Type: text/plain; charset="UTF-8"',
      'MIME-Version: 1.0',
    ];

    final message = '${headers.join('\r\n')}\r\n\r\n${draft.body}';

    return _base64UrlEncode(message);
  }

  String _base64UrlEncode(String value) {
    final bytes = value.codeUnits;

    final base64 = _base64Encode(bytes);

    return base64.replaceAll('+', '-').replaceAll('/', '_').replaceAll('=', '');
  }

  String _base64Encode(List<int> bytes) {
    const alphabet =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

    final buffer = StringBuffer();

    for (var i = 0; i < bytes.length; i += 3) {
      final remaining = bytes.length - i;

      final b1 = bytes[i];
      final b2 = remaining > 1 ? bytes[i + 1] : 0;
      final b3 = remaining > 2 ? bytes[i + 2] : 0;

      final value = (b1 << 16) | (b2 << 8) | b3;

      buffer.write(alphabet[(value >> 18) & 0x3F]);
      buffer.write(alphabet[(value >> 12) & 0x3F]);
      buffer.write(remaining > 1 ? alphabet[(value >> 6) & 0x3F] : '=');
      buffer.write(remaining > 2 ? alphabet[value & 0x3F] : '=');
    }

    return buffer.toString();
  }
}
