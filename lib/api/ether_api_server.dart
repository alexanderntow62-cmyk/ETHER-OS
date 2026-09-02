import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import '../ai/brain/ether_brain.dart';
import '../ai/online/ether_ai_engine.dart';
import '../ai/online/gemini_ai_config.dart';
import '../ai/online/gemini_ether_engine.dart';
import '../ai/online/ether_unavailable_ai_engine.dart';
import '../ai/brain/ether_persistent_memory.dart';
import '../fek/ether_fek_coordinator.dart';

class EtherApiServer {
  final String host;
  final int port;
  final String apiKey;

  HttpServer? _server;

  late final EtherBrain brain;
  late final EtherFEKCoordinator coordinator;
  late final EtherAIEngine providerAI;

  bool _initialized = false;

  EtherApiServer({
    this.host = '127.0.0.1',
    this.port = 8787,
    this.apiKey = 'ether-local-dev-key',
  });

  bool get isRunning => _server != null;

  Future<void> initialize() async {
    if (_initialized) return;

    // IMPORTANT:
    // The application Brain talks to this API.
    // Therefore the API server itself MUST use a direct provider
    // and must never route its provider call back through /v1/chat.

    providerAI = GeminiAIConfig.hasGeminiKey
        ? GeminiEtherEngine(apiKey: GeminiAIConfig.apiKey)
        : const EtherUnavailableAIEngine();

    brain = EtherBrain(
      persistentMemory: EtherPersistentMemory(store: InMemoryMemoryStore()),
      onlineAI: providerAI,
    );

    await brain.initialize();

    coordinator = EtherFEKCoordinator(brain: brain);
    await coordinator.initialize();

    _initialized = true;
  }

  Future<void> start() async {
    await initialize();
    if (_server != null) return;

    final handler = Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(_authMiddleware())
        .addHandler(_router().call);

    _server = await shelf_io.serve(handler, host, port);
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
  }

  Middleware _authMiddleware() {
    return (Handler inner) {
      return (Request request) {
        if (request.url.path == 'health') {
          return inner(request);
        }

        final suppliedKey = request.headers['x-ether-api-key'];

        if (suppliedKey != apiKey) {
          return Response(
            401,
            body: jsonEncode({'success': false, 'error': 'Unauthorized'}),
            headers: {'content-type': 'application/json'},
          );
        }

        return inner(request);
      };
    };
  }

  Router _router() {
    final router = Router();

    router.get('/health', (Request request) {
      return _json({
        'success': true,
        'service': 'ETHER API',
        'status': 'healthy',
      });
    });

    router.get('/v1/status', (Request request) {
      return _json({
        'success': true,
        'service': 'ETHER API',
        'version': '1.0.0',
        'brain': 'ready',
        'fek': 'ready',
        'business': 'ready',
        'memory': 'ready',
      });
    });

    router.post('/v1/chat', (Request request) async {
      final body = await _body(request);
      final message = body['message'];
      final context = body['context'];

      if (message is! String || message.trim().isEmpty) {
        return _json({
          'success': false,
          'error': 'message is required',
        }, status: 400);
      }

      final response = await providerAI.generate(
        message: message.trim(),
        context: context is String ? context : null,
      );

      return _json({
        'success': true,
        'type': 'chat',
        'message': message.trim(),
        'response': response,
      });
    });

    router.post('/v1/think', (Request request) async {
      final body = await _body(request);
      final input = body['input'];

      if (input is! String || input.trim().isEmpty) {
        return _json({
          'success': false,
          'error': 'input is required',
        }, status: 400);
      }

      final response = await coordinator.process(input.trim());

      return _json({
        'success': true,
        'type': 'thought',
        'input': input.trim(),
        'status': 'processed',
        'response': response,
      });
    });

    router.get('/v1/skills', (Request request) {
      return _json({
        'success': true,
        'skills': [
          'calculator',
          'memory',
          'voice',
          'business',
          'planning',
          'execution',
        ],
      });
    });

    router.post('/v1/tasks', (Request request) async {
      final body = await _body(request);
      final task = body['task'];

      if (task is! String || task.trim().isEmpty) {
        return _json({
          'success': false,
          'error': 'task is required',
        }, status: 400);
      }

      final id = 'task-${DateTime.now().millisecondsSinceEpoch}';

      final response = await coordinator.process(task.trim());

      return _json({
        'success': true,
        'task': {
          'id': id,
          'description': task.trim(),
          'status': 'completed',
          'result': response,
        },
      });
    });

    router.get('/v1/tasks/<id>', (Request request, String id) {
      return _json({
        'success': true,
        'task': {'id': id, 'status': 'queued'},
      });
    });

    router.post('/v1/business/plan', (Request request) async {
      final body = await _body(request);
      final goal = body['goal'];

      if (goal is! String || goal.trim().isEmpty) {
        return _json({
          'success': false,
          'error': 'goal is required',
        }, status: 400);
      }

      return _json({
        'success': true,
        'type': 'business_plan',
        'status': 'awaiting_approval',
        'financial_action': false,
        'requires_user_approval': true,
        'plan': {
          'goal': goal,
          'steps': [
            'Research opportunity',
            'Evaluate feasibility',
            'Create execution plan',
            'Measure results',
          ],
          'estimated_cost': 0,
        },
      });
    });

    router.post('/v1/business/approve', (Request request) async {
      final body = await _body(request);
      final approved = body['approved'];

      if (approved is! bool) {
        return _json({
          'success': false,
          'error': 'approved must be boolean',
        }, status: 400);
      }

      return _json({
        'success': true,
        'approved': approved,
        'status': approved ? 'approved' : 'rejected',
        'financial_actions_allowed': false,
        'message': approved
            ? 'Plan approved. Financial transactions still require explicit authorization.'
            : 'Plan rejected.',
      });
    });

    router.all('/<ignored|.*>', (Request request) {
      return _json({
        'success': false,
        'error': 'Endpoint not found',
        'path': request.url.path,
      }, status: 404);
    });

    return router;
  }

  Future<Map<String, dynamic>> _body(Request request) async {
    final raw = await request.readAsString();

    if (raw.trim().isEmpty) {
      return <String, dynamic>{};
    }

    final decoded = jsonDecode(raw);

    if (decoded is! Map) {
      throw const FormatException('JSON body must be an object');
    }

    return Map<String, dynamic>.from(decoded);
  }

  Response _json(Map<String, dynamic> data, {int status = 200}) {
    return Response(
      status,
      body: jsonEncode(data),
      headers: {'content-type': 'application/json'},
    );
  }
}
