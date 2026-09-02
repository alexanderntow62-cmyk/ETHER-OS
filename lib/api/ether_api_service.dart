import 'ether_api_server.dart';

class EtherApiService {
  EtherApiServer? _server;

  bool get isRunning => _server?.isRunning ?? false;

  Future<void> start({
    String host = '127.0.0.1',
    int port = 8787,
    String apiKey = 'ether-local-dev-key',
  }) async {
    if (isRunning) return;

    _server = EtherApiServer(host: host, port: port, apiKey: apiKey);

    await _server!.start();
  }

  Future<void> stop() async {
    await _server?.stop();
    _server = null;
  }
}
