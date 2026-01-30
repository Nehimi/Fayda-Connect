import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import '../theme/l10n.dart';

class FirebaseTranslationUploader {
  static Future<void> uploadTranslations() async {
    final database = FirebaseDatabase.instance;
    final translationsRef = database.ref('translations');

    // Get all translations from L10n
    final Map<String, dynamic> translationsData = {
      'en': L10n._en,
      'am': L10n._am,
      'om': L10n._om,
      'ti': L10n._ti,
    };

    print('Uploading translations to Firebase...');

    try {
      // Upload each language
      for (String lang in translationsData.keys) {
        await translationsRef.child(lang).set(translationsData[lang]);
        print('✅ Uploaded ${lang.toUpperCase()} translations');
      }

      // Add metadata
      await translationsRef.child('metadata').set({
        'lastUpdated': DateTime.now().toIso8601String(),
        'languages': ['en', 'am', 'om', 'ti'],
        'totalKeys': L10n._en.length,
        'version': '1.0.4'
      });

      print('✅ All translations uploaded successfully!');
      print('📊 Total keys: ${L10n._en.length}');
      print('🌍 Languages: English, Amharic, Oromo, Tigrigna');

    } catch (e) {
      print('❌ Error uploading translations: $e');
    }
  }

  static Future<Map<String, dynamic>?> downloadTranslations(String language) async {
    final database = FirebaseDatabase.instance;
    final translationsRef = database.ref('translations/$language');

    try {
      final snapshot = await translationsRef.get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      print('❌ Error downloading translations: $e');
      return null;
    }
  }

  static void printTranslationSummary() {
    print('\n📋 TRANSLATION SUMMARY');
    print('=' * 50);
    print('🇬🇧 English: ${L10n._en.length} keys');
    print('🇪🇹 Amharic: ${L10n._am.length} keys');
    print('🇴🇲 Oromo: ${L10n._om.length} keys');
    print('🇪🇷 Tigrigna: ${L10n._ti.length} keys');
    
    print('\n🔑 Sample keys:');
    final sampleKeys = [
      'step_visit_cbe',
      'rem_pass_title',
      'status_comp',
      'academy',
      'fayda_fin'
    ];
    
    for (String key in sampleKeys) {
      print('\n$key:');
      print('  EN: ${L10n._en[key] ?? 'MISSING'}');
      print('  AM: ${L10n._am[key] ?? 'MISSING'}');
      print('  OM: ${L10n._om[key] ?? 'MISSING'}');
      print('  TI: ${L10n._ti[key] ?? 'MISSING'}');
    }
  }
}
