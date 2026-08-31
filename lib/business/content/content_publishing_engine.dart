import 'content_objective.dart';

enum PublishingStatus { prepared, approvalRequired, published, failed }

class PublishingRequest {
  final String title;
  final ContentPlatform platform;
  final String description;
  final List<String> hashtags;

  const PublishingRequest({
    required this.title,
    required this.platform,
    required this.description,
    this.hashtags = const [],
  });
}

class PublishingResult {
  final PublishingStatus status;
  final String message;

  const PublishingResult({required this.status, required this.message});
}

class ContentPublishingEngine {
  PublishingResult prepare(PublishingRequest request) {
    return PublishingResult(
      status: PublishingStatus.approvalRequired,
      message:
          'Publishing is prepared. Authorized platform access and final publishing permission are required.',
    );
  }
}
