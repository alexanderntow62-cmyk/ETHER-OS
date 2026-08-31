import 'content_objective.dart';

enum ContentPermission { autonomous, approvalRequired, financial }

class ContentPlanStep {
  final String id;
  final String title;
  final String description;
  final ContentPermission permission;

  const ContentPlanStep({
    required this.id,
    required this.title,
    required this.description,
    this.permission = ContentPermission.autonomous,
  });

  bool get requiresApproval => permission != ContentPermission.autonomous;
}

class ContentPlan {
  final ContentObjective objective;
  final List<ContentPlanStep> steps;

  const ContentPlan({required this.objective, required this.steps});
}
