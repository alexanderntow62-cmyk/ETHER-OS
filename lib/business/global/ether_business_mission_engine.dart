import 'ether_business_creator.dart';

class EtherBusinessMission {
  final String title;
  final String description;
  final List<String> phases;

  const EtherBusinessMission({
    required this.title,
    required this.description,
    required this.phases,
  });
}

class EtherBusinessMissionEngine {
  const EtherBusinessMissionEngine();

  EtherBusinessMission createMission(EtherCreatedBusiness business) {
    return EtherBusinessMission(
      title: 'Operate ${business.opportunity.name}',
      description: business.mission,
      phases: [
        'DISCOVER',
        'VALIDATE',
        'BUILD',
        'LAUNCH',
        'OPERATE',
        'MEASURE',
        'LEARN',
        'SCALE',
      ],
    );
  }
}
