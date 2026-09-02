import '../google_integration_models.dart';
import 'google_scopes.dart';

/// Authentication contract for Google Workspace.
///
/// Implementations must use OAuth.
/// ETHER must never request or store a user's Google password.
abstract class GoogleAuthService {
  Future<GoogleAccount?> connect({required Set<GooglePermission> permissions});

  Future<GoogleAccount?> currentAccount();

  Future<void> disconnect();

  bool get isConnected;
}
