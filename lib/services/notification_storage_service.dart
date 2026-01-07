import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationStorageProvider = Provider((ref) => NotificationStorageService());

class NotificationStorageService {
  static const String _key = 'user_notifications';

  Future<List<AppNotification>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => AppNotification.fromJson(e)).toList();
  }

  Future<void> saveNotification(AppNotification notification) async {
    final notifications = await getNotifications();
    notifications.insert(0, notification); // Add to top
    await _saveList(notifications);
  }

  Future<void> markAsRead(String id) async {
    final notifications = await getNotifications();
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index] = AppNotification(
        id: notifications[index].id,
        title: notifications[index].title,
        body: notifications[index].body,
        timestamp: notifications[index].timestamp,
        isRead: true,
      );
      await _saveList(notifications);
    }
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  Future<void> _saveList(List<AppNotification> notifications) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = json.encode(notifications.map((n) => n.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }
}
