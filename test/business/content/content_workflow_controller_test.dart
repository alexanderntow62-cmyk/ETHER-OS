import 'package:flutter_test/flutter_test.dart';
import 'package:ether_os/business/content/content_workflow_controller.dart';

void main() {
  test('executes complete content preparation workflow', () {
    final controller = ContentWorkflowController();

    const objective =
        'Create a faceless YouTube channel about AI and turn every video into TikToks';

    final result = controller.execute(objective);

    expect(result.objective, objective);
    expect(result.report, contains('ETHER CONTENT WORKFLOW'));
    expect(result.report, contains('SCRIPTS:'));
    expect(result.report, contains('REPURPOSED SHORTS:'));
    expect(result.report, contains('FINANCIAL SAFETY:'));
  });
}
