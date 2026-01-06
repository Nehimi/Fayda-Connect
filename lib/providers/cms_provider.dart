import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/service_model.dart';

final benefitsProvider = StreamProvider<List<PartnerBenefit>>((ref) {
  final database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://fayda-connect-default-rtdb.firebaseio.com',
  );
  final dbRef = database.ref('partner_benefits');
  
  return dbRef.onValue.map((event) {
    debugPrint('CMS: Received benefits data update');
    final data = event.snapshot.value;
    if (data == null) return [];
    
    if (data is Map) {
      return data.entries.map((entry) {
        final value = entry.value as Map;
        return PartnerBenefit.fromFirestore(Map<String, dynamic>.from(value), entry.key.toString());
      }).toList();
    } else if (data is List) {
      final list = <PartnerBenefit>[];
      for (int i = 0; i < data.length; i++) {
        if (data[i] != null) {
          final value = data[i] as Map;
          list.add(PartnerBenefit.fromFirestore(Map<String, dynamic>.from(value), i.toString()));
        }
      }
      return list;
    }
    return [];
  });
});

final newsProvider = StreamProvider<List<NewsUpdate>>((ref) {
  final database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://fayda-connect-default-rtdb.firebaseio.com',
  );
  final dbRef = database.ref('news_updates');
  
  return dbRef.orderByChild('date').onValue.map((event) {
    debugPrint('CMS: Received news data update');
    final data = event.snapshot.value;
    if (data == null) return [];
    
    final list = <NewsUpdate>[];
    if (data is Map) {
      for (final entry in data.entries) {
        final value = entry.value as Map;
        list.add(NewsUpdate.fromFirestore(Map<String, dynamic>.from(value), entry.key.toString()));
      }
    } else if (data is List) {
      for (int i = 0; i < data.length; i++) {
        if (data[i] != null) {
          final value = data[i] as Map;
          list.add(NewsUpdate.fromFirestore(Map<String, dynamic>.from(value), i.toString()));
        }
      }
    }
    
    return list.reversed.toList();
  });
});

Future<void> deleteNews(String newsId) async {
  final database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://fayda-connect-default-rtdb.firebaseio.com',
  );
  await database.ref('news_updates/$newsId').remove();
}

class NewsSeenNotifier extends StateNotifier<String?> {
  NewsSeenNotifier() : super(null) {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('last_seen_news_id');
  }

  Future<void> markAsSeen(String? newsId) async {
    if (newsId == null || newsId == state) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_seen_news_id', newsId);
    state = newsId;
  }
}

final newsSeenProvider = StateNotifierProvider<NewsSeenNotifier, String?>((ref) {
  return NewsSeenNotifier();
});

final unreadNewsCountProvider = Provider<int>((ref) {
  final newsAsync = ref.watch(newsProvider);
  final lastSeenId = ref.watch(newsSeenProvider);

  return newsAsync.when(
    data: (news) {
      if (news.isEmpty) return 0;
      if (lastSeenId == null) return news.length;
      
      final index = news.indexWhere((item) => item.id == lastSeenId);
      if (index == -1) return news.length; // Last seen is gone, show all
      return index; // Because list is reversed (newest first)
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
});
