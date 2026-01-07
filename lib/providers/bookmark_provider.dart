import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final bookmarksProvider = StateNotifierProvider<BookmarksNotifier, Set<String>>((ref) {
  return BookmarksNotifier();
});

class BookmarksNotifier extends StateNotifier<Set<String>> {
  BookmarksNotifier() : super({}) {
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? bookmarkedIds = prefs.getStringList('bookmarked_tutorials');
    if (bookmarkedIds != null) {
      state = bookmarkedIds.toSet();
    }
  }

  Future<void> toggleBookmark(String id) async {
    final newState = Set<String>.from(state);
    if (newState.contains(id)) {
      newState.remove(id);
    } else {
      newState.add(id);
    }
    state = newState;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bookmarked_tutorials', state.toList());
  }

  bool isBookmarked(String id) => state.contains(id);
}
