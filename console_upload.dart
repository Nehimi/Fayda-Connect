import 'dart:convert';
import 'dart:io';

void main() async {
  print('🌍 ETHIOPIAN TRANSLATIONS FIREBASE UPLOAD');
  print('=' * 50);
  
  // Read the translations file
  final file = File('translations_export.json');
  if (!await file.exists()) {
    print('❌ translations_export.json not found');
    print('💡 Make sure you are in the project root directory');
    return;
  }

  final content = await file.readAsString();
  final translations = jsonDecode(content);

  print('📊 Translation Summary:');
  for (String lang in translations['translations'].keys) {
    final count = translations['translations'][lang].length;
    print('  ${getFlag(lang)} $lang: $count keys');
  }

  print('\n🔗 Firebase Details:');
  print('  Project: fayda-connect');
  print('  Database: https://fayda-connect-default-rtdb.firebaseio.com');
  print('  Path: /translations');

  print('\n📋 CONSOLE UPLOAD INSTRUCTIONS:');
  print('=' * 50);
  
  print('\n🔥 METHOD 1: Firebase CLI (Recommended)');
  print('1. Install Firebase CLI: npm install -g firebase-tools');
  print('2. Login: firebase login');
  print('3. Run: firebase database:set /translations "\$(cat translations_export.json)" --project fayda-connect');

  print('\n🌐 METHOD 2: curl Command');
  print('curl -X PUT "https://fayda-connect-default-rtdb.firebaseio.com/translations.json" \\');
  print('  -H "Content-Type: application/json" \\');
  print('  -d @translations_export.json');

  print('\n📱 METHOD 3: PowerShell (Windows)');
  print('Invoke-RestMethod -Uri "https://fayda-connect-default-rtdb.firebaseio.com/translations.json" \\');
  print('  -Method Put -ContentType "application/json" -InFile "translations_export.json"');

  print('\n🔍 METHOD 4: Firebase Console');
  print('1. Go to: https://console.firebase.google.com/project/fayda-connect/database');
  print('2. Click "Import JSON"');
  print('3. Select: translations_export.json');
  print('4. Import to: /translations');

  print('\n✅ TRANSLATIONS READY FOR UPLOAD!');
  print('📄 File: translations_export.json');
  print('📊 Size: ${content.length} characters');
  print('🌍 Languages: ${translations['translations'].keys.join(', ')}');
  
  // Show sample translations
  print('\n🔍 SAMPLE TRANSLATIONS:');
  final sampleKeys = ['step_visit_cbe', 'rem_pass_title', 'fayda_fin'];
  
  for (String key in sampleKeys) {
    print('\n$key:');
    for (String lang in translations['translations'].keys) {
      final translation = translations['translations'][lang][key] ?? 'MISSING';
      print('  ${getFlag(lang)} $lang: $translation');
    }
  }
}

String getFlag(String lang) {
  switch (lang) {
    case 'en': return '🇬🇧';
    case 'am': return '🇪🇹';
    case 'om': return '🇴🇲';
    case 'ti': return '🇪🇷';
    default: return '🌍';
  }
}
