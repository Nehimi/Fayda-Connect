import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppLanguage {
  english('EN', 'English'),
  amharic('AM', 'Amharic'),
  oromiffa('OR', 'Oromiffa'),
  tigrigna('TI', 'Tigrigna');

  final String code;
  final String name;
  const AppLanguage(this.code, this.name);
}

final languageProvider = StateProvider<AppLanguage>((ref) => AppLanguage.english);
