import 'google_token.dart';

/// Supplies a valid Google access token to API clients.

abstract class GoogleAuthorizedClient {
  Future<GoogleToken?> token();

  Future<void> revoke();
}
