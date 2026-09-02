/// Configuration required to connect ETHER to Google OAuth.
///
/// No secrets belong in this file or in source control.
class GoogleOAuthConfig {
  final String clientId;
  final String redirectUri;

  const GoogleOAuthConfig({required this.clientId, required this.redirectUri});
}
