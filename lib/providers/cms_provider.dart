import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/service_model.dart';
import '../models/news_item.dart';

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

final newsProvider = StreamProvider<List<NewsItem>>((ref) {
  final database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://fayda-connect-default-rtdb.firebaseio.com',
  );
  final dbRef = database.ref('news_updates');
  
  return dbRef.orderByChild('date').onValue.map((event) {
    debugPrint('CMS: Received news data update');
    final data = event.snapshot.value;
    if (data == null) return [];
    
    final list = <NewsItem>[];
    if (data is Map) {
      for (final entry in data.entries) {
        final value = entry.value as Map;
        list.add(NewsItem.fromMap(entry.key.toString(), Map<dynamic, dynamic>.from(value)));
      }
    } else if (data is List) {
      for (int i = 0; i < data.length; i++) {
        if (data[i] != null) {
          final value = data[i] as Map;
          list.add(NewsItem.fromMap(i.toString(), Map<dynamic, dynamic>.from(value)));
        }
      }
    }
    
    return list.reversed.toList();
  });
});

final promoVisibilityProvider = StreamProvider<bool>((ref) {
  final database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://fayda-connect-default-rtdb.firebaseio.com',
  );
  return database.ref('settings/show_premium_promo').onValue.map((event) {
    // Default to true if null
    return (event.snapshot.value as bool?) ?? true;
  });
});

final partnerVisibilityProvider = StreamProvider<bool>((ref) {
  final database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://fayda-connect-default-rtdb.firebaseio.com',
  );
  return database.ref('settings/show_partners').onValue.map((event) {
    // Default to true if null
    return (event.snapshot.value as bool?) ?? true;
  });
});

Future<void> deleteNews(String newsId) async {
  final database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://fayda-connect-default-rtdb.firebaseio.com',
  );
  await database.ref('news_updates/$newsId').remove();
}

class NewsSeenNotifier extends StateNotifier<Map<String, String>> {
  NewsSeenNotifier() : super({}) {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    state = {
      'official': prefs.getString('last_seen_official') ?? '',
      'academy': prefs.getString('last_seen_academy') ?? '',
    };
  }

  Future<void> markAsSeen(String newsId, {bool isAcademy = false}) async {
    final key = isAcademy ? 'academy' : 'official';
    if (state[key] == newsId) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_seen_$key', newsId);
    
    // Update state with the correct key variable value
    final newState = Map<String, String>.from(state);
    newState[key] = newsId;
    state = newState;
  }

  bool isNew(NewsItem item) {
    final key = item.type == NewsType.academy ? 'academy' : 'official';
    final lastSeen = state[key] ?? '';
    if (lastSeen.isEmpty) return true;
    
    // Simple comparison: items are returned newest first in newsProvider
    // So if it's not the last seen ID and we don't have a better sorting, 
    // we'd need the full list to know if one is newer. 
    // However, the provider can handle this for us.
    return false; // Will be determined by provider index
  }
}

final newsSeenStatusProvider = StateNotifierProvider<NewsSeenNotifier, Map<String, String>>((ref) {
  return NewsSeenNotifier();
});

final unreadNewsCountProvider = Provider<int>((ref) {
  final newsAsync = ref.watch(newsProvider);
  final seenMap = ref.watch(newsSeenStatusProvider);

  return newsAsync.when(
    data: (news) {
      if (news.isEmpty) return 0;
      
      final officialNews = news.where((n) => n.type != NewsType.academy).toList();
      final academyNews = news.where((n) => n.type == NewsType.academy).toList();

      int count = 0;
      
      // Count Official unreads
      final lastOff = seenMap['official'] ?? '';
      if (lastOff.isEmpty) {
        count += officialNews.length;
      } else {
        final idx = officialNews.indexWhere((n) => n.id == lastOff);
        count += (idx == -1) ? officialNews.length : idx;
      }

      // Count Academy unreads
      final lastAcad = seenMap['academy'] ?? '';
      if (lastAcad.isEmpty) {
        count += academyNews.length;
      } else {
        final idx = academyNews.indexWhere((n) => n.id == lastAcad);
        count += (idx == -1) ? academyNews.length : idx;
      }

      return count;
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
});
