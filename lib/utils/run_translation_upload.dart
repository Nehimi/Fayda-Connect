import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_translation_uploader.dart';

Future<void> main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  print('🚀 Starting Firebase Translation Upload Process');
  print('=' * 60);

  // Show translation summary
  FirebaseTranslationUploader.printTranslationSummary();

  print('\n' + '=' * 60);
  print('📤 Starting upload to Firebase...');
  
  // Upload translations
  await FirebaseTranslationUploader.uploadTranslations();

  print('\n' + '=' * 60);
  print('✅ Translation upload process completed!');
}
