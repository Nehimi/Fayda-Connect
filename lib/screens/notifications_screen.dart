import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../providers/notification_provider.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../theme/l10n.dart';
import '../providers/language_provider.dart';

import '../models/news_item.dart';
import '../models/notification_model.dart';
import '../providers/cms_provider.dart';
import 'news_list_screen.dart';
import 'academy_screen.dart';
import '../utils/responsive.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final lang = ref.watch(languageProvider);
    final r = context.responsive;

    final newsAsync = ref.watch(newsProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text(L10n.get(lang, 'notifications')),
        backgroundColor: Colors.transparent,
        actions: [
          if (notifications.isNotEmpty)
            IconButton(
              icon: const Icon(LucideIcons.trash2, color: AppColors.textDim),
              onPressed: () => _showClearConfirmation(context, ref),
            ),
        ],
      ),
      body: newsAsync.when(
        data: (news) {
          // Flatten items into a single list for a unified "Pro" Inbox
          // We show latest 10 news items mixed with app-generated alerts
          final List<dynamic> unifiedItems = [...notifications, ...news.take(15)];
          
          // Sort unified list by date (newest first)
          unifiedItems.sort((a, b) {
            final dateA = a is AppNotification ? a.timestamp : (a as NewsItem).date;
            final dateB = b is AppNotification ? b.timestamp : (b as NewsItem).date;
            return dateB.compareTo(dateA);
          });

          if (unifiedItems.isEmpty) {
            return _buildEmptyState(lang, LucideIcons.bellOff, 'no_updates');
          }

          return ListView.builder(
            padding: EdgeInsets.all(r.getSpacing(16)),
            itemCount: unifiedItems.length,
            itemBuilder: (context, index) {
              final item = unifiedItems[index];
              if (item is AppNotification) {
                return _buildNotificationItem(item, ref, r);
              } else {
                return _buildNewsNotificationItem(context, item as NewsItem, ref);
              }
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }



  Widget _buildEmptyState(AppLanguage lang, IconData icon, String key) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.textDim.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            L10n.get(lang, key),
            style: const TextStyle(color: AppColors.textDim, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(AppNotification notification, WidgetRef ref, Responsive r) {
    return Padding(
      padding: EdgeInsets.only(bottom: r.getSpacing(12)),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: InkWell(
          onTap: () => ref.read(notificationsProvider.notifier).markAsRead(notification.id),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: EdgeInsets.all(r.getSpacing(14)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(r.getSpacing(10)),
                  decoration: BoxDecoration(
                    color: notification.isRead ? Colors.grey.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.bell,
                    color: notification.isRead ? AppColors.textDim : AppColors.primary,
                    size: r.getIconSize(20),
                  ),
                ),
                SizedBox(width: r.getSpacing(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                color: AppColors.textMain,
                                fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                                fontSize: r.getFontSize(15),
                              ),
                            ),
                          ),
                          Text(
                            _formatDate(notification.timestamp),
                            style: TextStyle(color: AppColors.textDim, fontSize: r.getFontSize(11)),
                          ),
                        ],
                      ),
                      SizedBox(height: r.getSpacing(4)),
                      Text(
                        notification.body,
                        style: TextStyle(
                          color: notification.isRead ? AppColors.textDim : AppColors.textMain,
                          fontSize: r.getFontSize(14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewsNotificationItem(BuildContext context, NewsItem item, WidgetRef ref) {
    final r = context.responsive;
    return Padding(
      padding: EdgeInsets.only(bottom: r.getSpacing(12)),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: InkWell(
          onTap: () {
             ref.read(newsSeenStatusProvider.notifier).markAsSeen(item.id, isAcademy: item.type == NewsType.academy);
             // Intelligent Navigation: Pro Choice
             if (item.type == NewsType.academy) {
               Navigator.push(context, MaterialPageRoute(builder: (context) => const AcademyScreen()));
             } else {
               Navigator.push(context, MaterialPageRoute(builder: (context) => const NewsListScreen()));
             }
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: EdgeInsets.all(r.getSpacing(14)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(r.getSpacing(10)),
                  decoration: BoxDecoration(
                    color: (item.type == NewsType.academy ? AppColors.primary : (item.type == NewsType.alert ? AppColors.error : AppColors.primary)).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.type == NewsType.academy ? LucideIcons.graduationCap : (item.type == NewsType.alert ? LucideIcons.alertCircle : LucideIcons.megaphone),
                    color: item.type == NewsType.academy ? AppColors.primary : (item.type == NewsType.alert ? AppColors.error : AppColors.primary),
                    size: r.getIconSize(20),
                  ),
                ),
                SizedBox(width: r.getSpacing(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    item.title,
                                    style: TextStyle(
                                      color: AppColors.textMain,
                                      fontWeight: FontWeight.bold,
                                      fontSize: r.getFontSize(15),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // Show blue dot only if it's truly unread in its category
                                _isNewsItemUnread(item, ref) ? Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(left: 8),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ) : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                          Text(
                            DateFormat('MMM d').format(item.date),
                            style: TextStyle(color: AppColors.textDim, fontSize: r.getFontSize(11)),
                          ),
                        ],
                      ),
                      SizedBox(height: r.getSpacing(4)),
                      Text(
                        item.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: AppColors.textMain, fontSize: r.getFontSize(14)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isNewsItemUnread(NewsItem item, WidgetRef ref) {
    final seenMap = ref.watch(newsSeenStatusProvider);
    final key = item.type == NewsType.academy ? 'academy' : 'official';
    final lastSeen = seenMap[key] ?? '';
    
    if (lastSeen.isEmpty) return true;
    
    final news = ref.watch(newsProvider).value ?? [];
    final filtered = news.where((n) => (item.type == NewsType.academy) ? n.type == NewsType.academy : n.type != NewsType.academy).toList();
    
    final itemIndex = filtered.indexWhere((n) => n.id == item.id);
    final lastSeenIndex = filtered.indexWhere((n) => n.id == lastSeen);
    
    if (itemIndex == -1) return false;
    if (lastSeenIndex == -1) return true;
    
    return itemIndex < lastSeenIndex; // Newest first
  }

  String _formatDate(DateTime date) {
    // Simple date formatting
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(date);
    } else if (difference.inDays < 7) {
      return DateFormat('E').format(date); // Mon, Tue...
    } else {
      return DateFormat('MMM d').format(date);
    }
  }

  void _showClearConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardSurface,
        title: const Text('Clear Notifications?', style: TextStyle(color: AppColors.textMain)),
        content: const Text(
          'This will remove all your notification history.',
          style: TextStyle(color: AppColors.textDim),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textDim)),
          ),
          TextButton(
            onPressed: () {
              ref.read(notificationsProvider.notifier).clearAll();
              Navigator.pop(context);
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
