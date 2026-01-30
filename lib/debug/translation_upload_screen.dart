import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'dart:io';

class TranslationUploadScreen extends ConsumerStatefulWidget {
  const TranslationUploadScreen({super.key});

  @override
  ConsumerState<TranslationUploadScreen> createState() => _TranslationUploadScreenState();
}

class _TranslationUploadScreenState extends ConsumerState<TranslationUploadScreen> {
  bool _isUploading = false;
  String _status = 'Ready to upload translations to Firebase';
  List<String> _logs = [];

  void _addLog(String message) {
    setState(() {
      _logs.add('${DateTime.now().toString().substring(11, 19)}: $message');
    });
  }

  Future<void> _uploadTranslations() async {
    setState(() {
      _isUploading = true;
      _status = 'Uploading...';
      _logs.clear();
    });

    try {
      _addLog('🚀 Starting translation upload...');
      
      final database = FirebaseDatabase.instance;
      final translationsRef = database.ref('translations');

      // Read the translations file
      final file = File('translations_export.json');
      if (!await file.exists()) {
        throw Exception('translations_export.json not found');
      }

      final content = await file.readAsString();
      final translations = jsonDecode(content);

      _addLog('📊 Found ${translations['translations'].keys.length} languages');
      
      // Upload each language
      for (String lang in translations['translations'].keys) {
        _addLog('📤 Uploading $lang...');
        await translationsRef.child(lang).set(translations['translations'][lang]);
        _addLog('✅ $lang uploaded successfully');
      }

      // Add metadata
      _addLog('📋 Adding metadata...');
      await translationsRef.child('metadata').set({
        'lastUpdated': DateTime.now().toIso8601String(),
        'languages': translations['translations'].keys.toList(),
        'totalKeys': translations['translations']['en'].length,
        'version': '1.0.4',
        'uploadedFrom': 'Flutter App'
      });

      _addLog('🎉 All translations uploaded successfully!');
      setState(() {
        _status = 'Upload completed successfully!';
      });

      // Verify upload
      _addLog('🔍 Verifying upload...');
      final snapshot = await translationsRef.get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        _addLog('✅ Verification successful!');
        _addLog('📊 Languages in database: ${data.keys.where((k) => k != 'metadata').join(', ')}');
      }

    } catch (e) {
      _addLog('❌ Error: $e');
      setState(() {
        _status = 'Upload failed: $e';
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Translation Upload'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status: $_status',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This will upload Ethiopian translations (English, Amharic, Oromo, Tigrigna) to Firebase Realtime Database.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _uploadTranslations,
                child: _isUploading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text('Uploading...'),
                        ],
                      )
                    : const Text('Upload Translations to Firebase'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Upload Logs:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _logs.isEmpty ? 'No logs yet. Click upload to start.' : _logs.join('\n'),
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
