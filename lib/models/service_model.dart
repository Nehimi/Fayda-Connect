import 'package:flutter/foundation.dart';

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
  final double priorityPoints;
  
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
    this.priorityPoints = 50.0,
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

class PartnerBenefit {
  final String id;
  final String title;
  final String description;
  final String iconName; // e.g., 'percent', 'trendingDown'
  final int colorHex;
  final String? deepLink; // Route to navigate to
  final List<String> features; // New dynamic field

  PartnerBenefit({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.colorHex,
    this.deepLink,
    this.features = const [],
  });

  factory PartnerBenefit.fromFirestore(Map<String, dynamic> data, String id) {
    // Ultra-safe feature parsing
    List<String> parsedFeatures = [];
    try {
      final Object? rawFeatures = data['features'];
      if (rawFeatures != null) {
        if (rawFeatures is String && rawFeatures.isNotEmpty) {
          parsedFeatures = rawFeatures.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        } else if (rawFeatures is List) {
          parsedFeatures = rawFeatures.map((e) => e?.toString() ?? "").where((e) => e.isNotEmpty).toList();
        }
      }
    } catch (e) {
      debugPrint("PartnerBenefit: Error parsing features: $e");
    }

    return PartnerBenefit(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      iconName: data['iconName'] ?? 'star',
      colorHex: data['colorHex'] ?? 0xFF000000,
      deepLink: data['deepLink'],
      features: parsedFeatures,
    );
  }
}


