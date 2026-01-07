import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/app_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';

import '../providers/cms_provider.dart';
import '../models/news_item.dart';
import '../providers/bookmark_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class AcademyScreen extends ConsumerWidget {
  const AcademyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final newsAsync = ref.watch(newsProvider);
    
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text('Identity Academy'),
        backgroundColor: Colors.transparent,
      ),
      body: newsAsync.when(
        data: (newsList) {
          final tutorials = newsList.where((n) => n.type == NewsType.academy).toList();

          // Mark latest Academy news as seen
          if (tutorials.isNotEmpty) {
            Future.microtask(() => ref.read(newsSeenStatusProvider.notifier).markAsSeen(tutorials.first.id, isAcademy: true));
          }
          
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text(
                'Master Your Digital ID',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textMain),
              ),
              const SizedBox(height: 8),
              const Text(
                'Short video guides to help you navigate Fayda Connect.',
                style: TextStyle(color: AppColors.textDim),
              ),
              const SizedBox(height: 32),
              if (tutorials.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text('No tutorials available yet.', style: TextStyle(color: AppColors.textDim)),
                  ),
                ),
              ...tutorials.map((item) => _buildTutorialCard(context, item, ref)).toList(),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildTutorialCard(BuildContext context, NewsItem item, WidgetRef ref) {
    final isBookmarked = ref.watch(bookmarksProvider).contains(item.id);
    // Basic logic to determine if it's a video or just an image update
    // For this task, we treat the 'imageUrl' as the Media Source
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _launchVideo(item.imageUrl),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    // Using a placeholder for video thumbnail if it's a youtube link, or the image itself
                    child: Image.network(
                      _isVideo(item.imageUrl) 
                        ? 'https://img.youtube.com/vi/${_getYoutubeId(item.imageUrl)}/hqdefault.jpg' // High quality thumb
                        : (item.imageUrl.isNotEmpty ? item.imageUrl : 'https://placehold.co/600x400/png'), 
                      height: 200, // Slightly taller for better proportions
                      width: double.infinity, 
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        height: 200, 
                        color: Colors.black12,
                        child: const Center(child: Icon(LucideIcons.video, size: 50, color: Colors.grey)),
                      ),
                    ),
                  ),
                  // Premium Play Button Overlay
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                    ),
                    child: const Icon(LucideIcons.play, color: Colors.white, size: 28),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: AppColors.textMain,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.content,
                    style: TextStyle(
                      color: AppColors.textMain.withValues(alpha: 0.7),
                      fontSize: 14,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Row(
                children: [
                  _buildGlassIconButton(
                    LucideIcons.share2, 
                    () => Share.share('Check out this tutorial on Fayda Connect: ${item.title}\n\n${item.imageUrl}'),
                  ),
                  const SizedBox(width: 12),
                  _buildGlassIconButton(
                    LucideIcons.bookmark, 
                    () => ref.read(bookmarksProvider.notifier).toggleBookmark(item.id),
                    active: isBookmarked,
                  ),
                  const Spacer(),
                  _buildWatchButton(() => _launchVideo(item.imageUrl)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isVideo(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  String _getYoutubeId(String url) {
    try {
      final RegExp regExp = RegExp(
        r'^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#&?]*).*',
        caseSensitive: false,
        multiLine: false,
      );
      final Match? match = regExp.firstMatch(url);
      if (match != null && match.groupCount >= 7) {
        String? id = match.group(7);
        return id ?? '';
      }
    } catch (e) {
      return '';
    }
    return '';
  }

  Future<void> _launchVideo(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
  Widget _buildGlassIconButton(IconData icon, VoidCallback onTap, {bool active = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: active ? AppColors.primary.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.1)),
            color: active ? AppColors.primary.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
          ),
          child: Icon(icon, color: active ? AppColors.primary : AppColors.textMain, size: 20),
        ),
      ),
    );
  }

  Widget _buildWatchButton(VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [AppColors.primary, Color(0xFF8B5CF6)], // Primary to Purple
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Watch Now',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
            SizedBox(width: 6),
            Icon(LucideIcons.arrowRight, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}
