/// OAuth token model for ETHER-OS Google integrations.
///
/// This model stores token metadata only.

class GoogleToken {
  final String accessToken;
  final String? refreshToken;
  final DateTime expiresAt;
  final Set<String> scopes;
  final String tokenType;

  const GoogleToken({
    required this.accessToken,
    this.refreshToken,
    required this.expiresAt,
    this.scopes = const <String>{},
    this.tokenType = 'Bearer',
  });

  bool get isExpired {
    return !DateTime.now().toUtc().isBefore(expiresAt.toUtc());
  }

  bool get isValid {
    return accessToken.isNotEmpty && !isExpired;
  }

  GoogleToken copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    Set<String>? scopes,
    String? tokenType,
  }) {
    return GoogleToken(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      scopes: scopes ?? this.scopes,
      tokenType: tokenType ?? this.tokenType,
    );
  }

  @override
  String toString() {
    return 'GoogleToken('
        'expiresAt: $expiresAt, '
        'scopes: $scopes, '
        'tokenType: $tokenType, '
        'hasRefreshToken: ${refreshToken != null}'
        ')';
  }
}
