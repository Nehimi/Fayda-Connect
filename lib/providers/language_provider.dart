import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage {
  english('EN', 'English'),
  amharic('AM', 'Amharic'),
  oromiffa('OR', 'Oromiffa'),
  tigrigna('TI', 'Tigrigna');

  final String code;
  final String name;
  const AppLanguage(this.code, this.name);
}

final languageProvider = StateNotifierProvider<LanguageNotifier, AppLanguage>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<AppLanguage> {
  LanguageNotifier() : super(AppLanguage.english) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('selected_language');
    if (langCode != null) {
      state = AppLanguage.values.firstWhere(
        (e) => e.code == langCode, 
        orElse: () => AppLanguage.english
      );
    }
  }

  Future<void> setLanguage(AppLanguage lang) async {
    state = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', lang.code);
  }
}
