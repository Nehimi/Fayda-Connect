enum BankType {
  online,
  appBased,
  inPerson,
}

class Bank {
  final String id;
  final String name;
  final String logo;
  final BankType type;
  final String? officialLink;
  final List<String> instructionSteps;
  final List<String> requirements;

  Bank({
    required this.id,
    required this.name,
    required this.logo,
    required this.type,
    this.officialLink,
    required this.instructionSteps,
    required this.requirements,
  });

  String get typeLabel {
    switch (type) {
      case BankType.online:
        return 'Online Portal';
      case BankType.appBased:
        return 'Mobile App';
      case BankType.inPerson:
        return 'Branch Visit';
    }
  }
}
