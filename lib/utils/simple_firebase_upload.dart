import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class SimpleFirebaseUploader {
  // Firebase project details from google-services.json
  static const String projectId = 'fayda-connect';
  static const String firebaseUrl = 'https://fayda-connect-default-rtdb.firebaseio.com/translations.json';
  static const String apiKey = 'AIzaSyD8JeqpJ9fYFvG01BbM0UVMTmPvpdQcgRQ';

  static Future<void> uploadTranslations() async {
    try {
      // Read the translations file
      final file = File('translations_export.json');
      if (!await file.exists()) {
        print('❌ translations_export.json not found');
        return;
      }

      final content = await file.readAsString();
      final translations = jsonDecode(content);

      print('📤 Uploading translations to Firebase...');
      print('🔗 Project: $projectId');
      print('📊 Total keys: ${translations['translations']['en'].length}');
      
      // Upload to Firebase Realtime Database
      final response = await http.put(
        Uri.parse(firebaseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(translations['translations']),
      );

      if (response.statusCode == 200) {
        print('✅ Translations uploaded successfully!');
        print('🌐 Firebase URL: $firebaseUrl');
        print('📊 Response: ${response.body}');
        
        // Verify upload by reading back
        await verifyUpload();
      } else {
        print('❌ Upload failed with status: ${response.statusCode}');
        print('📊 Response: ${response.body}');
      }
    } catch (e) {
      print('❌ Error uploading translations: $e');
    }
  }

  static Future<void> verifyUpload() async {
    try {
      print('\n🔍 Verifying upload...');
      final response = await http.get(Uri.parse(firebaseUrl));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Upload verified successfully!');
        print('📊 Languages available: ${data.keys}');
        for (String lang in data.keys) {
          final count = data[lang] is Map ? data[lang].length : 'N/A';
          print('  - $lang: $count keys');
        }
      } else {
        print('❌ Verification failed: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error verifying upload: $e');
    }
  }
}

void main() {
  SimpleFirebaseUploader.uploadTranslations();
}
