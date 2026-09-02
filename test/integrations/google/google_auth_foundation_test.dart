import 'package:flutter_test/flutter_test.dart';

import 'package:ether_os/integrations/google/auth/google_scopes.dart';
import 'package:ether_os/integrations/google/auth/google_token.dart';

void main() {
  group('Google OAuth foundation', () {
    test('Gmail read permission maps to Gmail readonly scope', () {
      final scopes = GoogleScopes.forPermissions({GooglePermission.gmailRead});

      expect(scopes, contains(GoogleScopes.gmailReadonly));
    });

    test('Gmail send permission maps to Gmail send scope', () {
      final scopes = GoogleScopes.forPermissions({GooglePermission.gmailSend});

      expect(scopes, contains(GoogleScopes.gmailSend));
    });

    test('Calendar write permission maps to calendar events scope', () {
      final scopes = GoogleScopes.forPermissions({
        GooglePermission.calendarWrite,
      });

      expect(scopes, contains(GoogleScopes.calendarEvents));
    });

    test('Calendar freebusy permission maps correctly', () {
      final scopes = GoogleScopes.forPermissions({
        GooglePermission.calendarFreeBusy,
      });

      expect(scopes, contains(GoogleScopes.calendarFreeBusy));
    });

    test('expired token reports expired', () {
      final token = GoogleToken(
        accessToken: 'test-token',
        expiresAt: DateTime.now().toUtc().subtract(const Duration(minutes: 1)),
      );

      expect(token.isExpired, isTrue);
    });
  });
}
