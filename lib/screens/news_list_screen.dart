import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/cms_provider.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../utils/responsive.dart';
import '../theme/l10n.dart';
import '../providers/language_provider.dart';
import '../widgets/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news_item.dart';
import '../providers/user_provider.dart';
import 'premium_screen.dart';

class NewsListScreen extends ConsumerWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsProvider);
    final currentLang = ref.watch(languageProvider);

    // 1. Filter out Academy posts from Official Feed to avoid duplication
    final filteredNews = newsAsync.value?.where((n) => n.type != NewsType.academy).toList() ?? [];

    // 2. Mark latest Official news as seen
    if (filteredNews.isNotEmpty) {
      Future.microtask(() => ref.read(newsSeenStatusProvider.notifier).markAsSeen(filteredNews.first.id, isAcademy: false));
    }

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textMain),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          L10n.get(currentLang, 'news_feed'),
          style: const TextStyle(
            color: AppColors.textMain, 
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
            fontSize: 22,
          ),
        ),
      ),
      body: newsAsync.when(
        data: (_) {
          if (filteredNews.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.bellOff, size: 64, color: AppColors.textDim.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text(
                    L10n.get(currentLang, 'no_updates'),
                    style: const TextStyle(color: AppColors.textDim, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: context.responsive.horizontalPadding, vertical: 10),
            itemCount: filteredNews.length,
            itemBuilder: (context, index) {
              final item = filteredNews[index];
              final isPremium = ref.watch(userProvider).isPremium;
              return _NewsUpdateCard(item: item, isUserPremium: isPremium);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Delete Update', style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to remove this update? This action will sync across all users.', style: TextStyle(color: AppColors.textDim)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textDim, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _NewsUpdateCard extends StatefulWidget {
  final NewsItem item;
  final bool isUserPremium;
  const _NewsUpdateCard({required this.item, required this.isUserPremium});

  @override
  State<_NewsUpdateCard> createState() => _NewsUpdateCardState();
}

class _NewsUpdateCardState extends State<_NewsUpdateCard> {
  bool _isExpanded = false;

  String _sanitizeImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    String sanitized = url.trim();
    
    // Convert popular image hosting links to direct links
    if (sanitized.contains('imgur.com') && !sanitized.contains('i.imgur.com')) {
      sanitized = sanitized.replaceFirst('imgur.com', 'i.imgur.com');
      // If it doesn't have an extension, assume .png
      if (!sanitized.contains(RegExp(r'\.(jpg|jpeg|png|gif|webp)$'))) {
        sanitized = '$sanitized.png';
      }
    }
    return sanitized;
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final sanitizedUrl = _sanitizeImageUrl(item.imageUrl);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Dismissible(
        key: Key(item.id),
        direction: DismissDirection.startToEnd,
        confirmDismiss: (_) => (context.findAncestorWidgetOfExactType<NewsListScreen>() as NewsListScreen)._confirmDelete(context),
        onDismissed: (_) async {
          await deleteNews(item.id);
          if (mounted) {
            CustomSnackBar.show(context, message: 'Update cleared from feed');
          }
        },
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 24),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(LucideIcons.trash2, color: AppColors.error, size: 28),
        ),
        child: InkWell(
          onTap: () {
            if (item.type == NewsType.premium) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PremiumScreen()));
            } else {
              setState(() => _isExpanded = !_isExpanded);
            }
          },
          borderRadius: BorderRadius.circular(24),
          child: GlassCard(
            padding: const EdgeInsets.all(20),
            borderRadius: 24,
            borderColor: item.type == NewsType.premium 
                ? AppColors.accent.withValues(alpha: 0.3) 
                : AppColors.primary.withValues(alpha: 0.15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (item.type == NewsType.premium ? AppColors.accent : AppColors.primary).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item.type == NewsType.premium ? LucideIcons.crown : (item.type == NewsType.promotion ? LucideIcons.shoppingBag : (item.type == NewsType.academy ? LucideIcons.graduationCap : LucideIcons.megaphone)), 
                            color: item.type == NewsType.premium ? AppColors.accent : AppColors.primary, 
                            size: 14
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: (item.type == NewsType.premium ? AppColors.accent : (item.type == NewsType.promotion ? Colors.orange : AppColors.primary)).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.type == NewsType.premium ? 'PRO BROADCAST' : (item.type == NewsType.promotion ? 'PROMOTION' : (item.type == NewsType.academy ? 'ACADEMY' : 'OFFICIAL')),
                            style: TextStyle(
                              color: item.type == NewsType.premium ? AppColors.accent : (item.type == NewsType.promotion ? Colors.orange : AppColors.primary),
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      DateFormat('MMM d, yyyy').format(item.date),
                      style: TextStyle(
                        color: AppColors.textDim,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (sanitizedUrl.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: SizedBox(
                        width: double.infinity,
                        height: _isExpanded ? null : 220,
                        child: Image.network(
                          _isVideo(sanitizedUrl) 
                            ? 'https://img.youtube.com/vi/${_getYoutubeId(sanitizedUrl)}/hqdefault.jpg'
                            : sanitizedUrl,
                          fit: _isExpanded ? BoxFit.fitWidth : BoxFit.cover,
                          alignment: Alignment.topCenter,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 220,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(LucideIcons.imageOff, color: AppColors.error.withValues(alpha: 0.3), size: 32),
                                const SizedBox(height: 8),
                                Text('Preview Unavailable', style: TextStyle(color: AppColors.textDim, fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  item.title,
                  style: TextStyle(
                    color: AppColors.textMain,
                    fontSize: context.responsive.getFontSize(18),
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Text(
                    item.content,
                    maxLines: _isExpanded ? null : 2,
                    overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textMain.withValues(alpha: 0.7),
                      fontSize: context.responsive.getFontSize(14),
                      height: 1.5,
                    ),
                  ),
                ),
                if (item.externalLink != null && item.externalLink!.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: item.type == NewsType.promotion ? Colors.orange : AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        if (item.type == NewsType.premium && !widget.isUserPremium) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PremiumScreen()));
                          return;
                        }
                        String urlStr = item.externalLink!.trim();
                        if (!urlStr.startsWith('http')) {
                          urlStr = 'https://$urlStr';
                        }
                        
                        final url = Uri.parse(urlStr);
                        try {
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          } else {
                            if (mounted) CustomSnackBar.show(context, message: 'Could not open link');
                          }
                        } catch (e) {
                           if (mounted) CustomSnackBar.show(context, message: 'Invalid link format');
                        }
                      },
                      icon: const Icon(LucideIcons.externalLink, size: 18),
                      label: const Text(
                        'VIEW MORE',
                        style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
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
}
