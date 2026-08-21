import 'package:flutter_test/flutter_test.dart';
import '../lib/business/business_mission_engine.dart';

void main() {
  test('ETHER creates a full autonomous business mission', () {
    final engine = BusinessMissionEngine();

    final mission = engine.createMission(
      id: 'mission_test_1',
      goal: 'Build a business for Ghanaian and international customers',
      businessName: 'Digital Business Services',
    );

    expect(mission.steps.length, 13);
    expect(mission.steps.first.title, 'Market research');
    expect(mission.steps[1].title, 'Customer research');
    expect(mission.steps[6].title, 'Sales channels');
    expect(mission.steps[11].title, 'Optimization');
    expect(mission.steps.last.title, 'Financial actions');
  });

  test('ETHER executes autonomous work and stops at financial boundary', () {
    final engine = BusinessMissionEngine();

    final mission = engine.createMission(
      id: 'mission_test_2',
      goal: 'Build an international service business',
      businessName: 'Digital Business Services',
    );

    final result = engine.executeAutonomousPreparation(mission);

    expect(result, contains('Market research'));
    expect(result, contains('Customer research'));
    expect(result, contains('Competitor research'));
    expect(result, contains('Define offer'));
    expect(result, contains('Pricing strategy'));
    expect(result, contains('Sales channels'));
    expect(result, contains('Marketing strategy'));
    expect(result, contains('Content preparation'));
    expect(result, contains('Operations'));
    expect(result, contains('Performance tracking'));
    expect(result, contains('Optimization'));
    expect(result, contains('FINANCIAL BOUNDARY'));
    expect(result, contains('APPROVAL REQUIRED'));
    expect(
      result,
      contains('ETHER cannot spend personal money'),
    );
  });
}
