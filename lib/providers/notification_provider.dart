import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';
import '../services/notification_storage_service.dart';

final notificationsProvider = StateNotifierProvider<NotificationNotifier, List<AppNotification>>((ref) {
  final storage = ref.read(notificationStorageProvider);
  return NotificationNotifier(storage);
});

class NotificationNotifier extends StateNotifier<List<AppNotification>> {
  final NotificationStorageService _storage;

  NotificationNotifier(this._storage) : super([]) {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    state = await _storage.getNotifications();
  }

  Future<void> addNotification(AppNotification notification) async {
    await _storage.saveNotification(notification);
    state = [notification, ...state];
  }

  Future<void> markAsRead(String id) async {
    await _storage.markAsRead(id);
    state = [
      for (final n in state)
        if (n.id == id)
          AppNotification(
            id: n.id,
            title: n.title,
            body: n.body,
            timestamp: n.timestamp,
            isRead: true,
          )
        else
          n
    ];
  }

  Future<void> clearAll() async {
    await _storage.clearAll();
    state = [];
  }
}
