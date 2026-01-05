enum ServiceType {
  online,
  appBased,
  inPerson,
}

class GeneralService {
  final String id;
  final String category; // 'Education', 'Passport', 'Business', 'Public Service'
  final String name;
  final String description;
  final String logo;
  final ServiceType type;
  final String? officialLink;
  final List<String> instructionSteps;
  final List<String> requirements;
  final double assistanceFee;

  GeneralService({
    required this.id,
    required this.category,
    required this.name,
    required this.description,
    required this.logo,
    required this.type,
    this.officialLink,
    required this.instructionSteps,
    required this.requirements,
    this.assistanceFee = 50.0,
  });

  String get typeLabel {
    switch (type) {
      case ServiceType.online:
        return 'Online Portal';
      case ServiceType.appBased:
        return 'Mobile App';
      case ServiceType.inPerson:
        return 'Visit Office';
    }
  }
}
