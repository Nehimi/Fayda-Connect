import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'premium_screen.dart';
import '../widgets/app_drawer.dart';
import '../theme/l10n.dart';

import '../models/service_category.dart';
import '../theme/colors.dart';
import '../widgets/category_card.dart';
import '../widgets/glass_card.dart';
import 'bank_list_screen.dart';
import 'service_list_screen.dart';
import '../models/service_model.dart';
import 'reminders_list_screen.dart';
import '../providers/service_provider.dart';
import '../providers/order_provider.dart';
import '../models/order_model.dart';
import '../theme/l10n.dart';
import '../providers/language_provider.dart';
import '../providers/reminder_provider.dart';
import 'bank_comparison_screen.dart';
import 'scanner_screen.dart';
import '../widgets/custom_snackbar.dart';
import '../services/auth_service.dart';
import 'auth/login_screen.dart';
import '../providers/auth_ui_provider.dart';
import '../utils/responsive.dart';
import '../providers/user_provider.dart';
import '../providers/cms_provider.dart';
import '../models/service_model.dart';
import '../models/news_item.dart';
import 'news_list_screen.dart';
import 'partner_offer_screen.dart';
import 'notifications_screen.dart';
import '../providers/notification_provider.dart';
import 'search_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeOrders = ref.watch(ordersProvider);
    final currentLang = ref.watch(languageProvider);
    final reminders = ref.watch(remindersProvider);
    final userAsync = ref.watch(authStateProvider);
    final appUser = ref.watch(userProvider);
    final isPremium = appUser.isPremium;
    final dynamicBenefits = ref.watch(benefitsProvider);
    final dynamicNews = ref.watch(newsProvider);
    final showPartners = ref.watch(partnerVisibilityProvider).value ?? true;
    final hidePremiumNews = ref.watch(hidePremiumNewsProvider).value ?? false;
    final r = context.responsive;
    
    final categories = [
      ServiceCategory(
        id: 'banking',
        title: L10n.get(currentLang, 'banking'),
        description: L10n.get(currentLang, 'desc_banking'),
        icon: LucideIcons.landmark,
        color: const Color(0xFF6366F1),
      ),
      ServiceCategory(
        id: 'passport',
        title: L10n.get(currentLang, 'passport'),
        description: L10n.get(currentLang, 'desc_passport'),
        icon: LucideIcons.contact,
        color: const Color(0xFF10B981),
      ),
      ServiceCategory(
        id: 'business',
        title: L10n.get(currentLang, 'business'),
        description: L10n.get(currentLang, 'desc_business'),
        icon: LucideIcons.briefcase,
        color: const Color(0xFFF59E0B),
      ),
      ServiceCategory(
        id: 'education',
        title: L10n.get(currentLang, 'education'),
        description: L10n.get(currentLang, 'desc_education'),
        icon: LucideIcons.graduationCap,
        color: const Color(0xFFEC4899),
      ),
      ServiceCategory(
        id: 'public',
        title: L10n.get(currentLang, 'public'),
        description: L10n.get(currentLang, 'desc_public'),
        icon: LucideIcons.shieldCheck,
        color: const Color(0xFF06B6D4),
      ),
      ServiceCategory(
        id: 'telecom',
        title: L10n.get(currentLang, 'telecom'),
        description: L10n.get(currentLang, 'desc_telecom'),
        icon: LucideIcons.smartphone,
        color: const Color(0xFF8B5CF6),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      drawer: const AppDrawer(),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Fixed Header
            Padding(
              padding: EdgeInsets.fromLTRB(
                r.horizontalPadding,
                r.getSpacing(48),
                r.horizontalPadding,
                r.getSpacing(20),
              ),
              child: Row(
                children: [
                  _MenuButton(),
                  SizedBox(width: r.getSpacing(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        userAsync.when(
                          data: (user) => Text(
                            user != null
                                ? '${_getGreetingPrefix(currentLang)}, ${user.displayName?.split(' ').first ?? 'User'}'
                                : _getGreetingPrefix(currentLang),
                            style: TextStyle(
                              color: AppColors.textDim,
                              fontSize: r.getFontSize(13),
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          loading: () => Text('...', style: TextStyle(color: AppColors.textDim, fontSize: 13)),
                          error: (_, __) => Text(_getGreetingPrefix(currentLang), style: TextStyle(color: AppColors.textDim, fontSize: 13)),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _getAppName(currentLang),
                            style: TextStyle(
                              color: AppColors.textMain,
                              fontSize: r.getFontSize(24),
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: r.getSpacing(8)),
                  _SearchButton(),
                  SizedBox(width: r.getSpacing(8)),
                  _NotificationBell(ref: ref),
                  SizedBox(width: r.getSpacing(4)),
                  _LanguageToggle(),
                ],
              ),
            ),

            // Scrolling Content
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.horizontalPadding,
                        vertical: r.getSpacing(8),
                      ),
                      child: dynamicNews.when(
                        data: (news) {
                          final latestPremium = news.where((n) => n.type == NewsType.premium).firstOrNull;
                          if (latestPremium != null && !hidePremiumNews) {
                            return _buildFeaturedNews(context, latestPremium, isPremium);
                          }

                          final latestOther = news.where((n) => n.type != NewsType.promotion && n.type != NewsType.academy).firstOrNull;
                          if (latestOther != null) {
                            return _buildFeaturedNews(context, latestOther, isPremium);
                          }

                          final showPromo = ref.watch(promoVisibilityProvider).value ?? true;
                          if (showPromo) {
                            return _buildPremiumPromo(context, isPremium);
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ),
                  ),

                  if (showPartners) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          context.responsive.horizontalPadding,
                          context.responsive.getSpacing(40),
                          context.responsive.horizontalPadding,
                          0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              L10n.get(currentLang, 'partner_benefits'),
                              style: TextStyle(
                                color: AppColors.textMain,
                                fontSize: context.responsive.getFontSize(18),
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BankComparisonScreen())),
                              child: const Text(
                                'View All',
                                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: dynamicBenefits.when(
                        data: (benefits) {
                          if (benefits.isEmpty) return const SizedBox.shrink();
                          final sortedBenefits = benefits.reversed.toList();
                          return _BenefitsCarousel(benefits: sortedBenefits);
                        },
                        loading: () => const Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (e, _) => const SizedBox.shrink(),
                      ),
                    ),
                  ],

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        context.responsive.horizontalPadding,
                        context.responsive.getSpacing(40),
                        context.responsive.horizontalPadding,
                        16,
                      ),
                      child: Text(
                        L10n.get(currentLang, 'explore'),
                        style: TextStyle(
                          color: AppColors.textMain,
                          fontSize: context.responsive.getFontSize(20),
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),

                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.responsive.horizontalPadding,
                    ),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: context.responsive.gridCrossAxisCount,
                        crossAxisSpacing: context.responsive.getSpacing(16),
                        mainAxisSpacing: context.responsive.getSpacing(16),
                        childAspectRatio: context.responsive.isTablet ? 1.0 : 0.85,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final category = categories[index];
                          return CategoryCard(
                            category: category,
                            onTap: () {
                              _handleNavigation(context, category);
                            },
                          );
                        },
                        childCount: categories.length,
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(r.getSpacing(20)),
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(height: r.getSpacing(40)),
                            Text(
                              L10n.get(currentLang, 'indep_provider'),
                              style: TextStyle(color: AppColors.textDim, fontSize: r.getFontSize(13), fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: r.getSpacing(6)),
                            Text(
                              L10n.get(currentLang, 'not_affiliated'),
                              style: TextStyle(color: AppColors.textDim.withValues(alpha: 0.8), fontSize: r.getFontSize(11)),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: r.getSpacing(120)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
}

IconData _getIconFromName(String name) {
  switch (name) {
    case 'percent': return LucideIcons.percent;
    case 'trendingDown': return LucideIcons.trendingDown;
    case 'gift': return LucideIcons.gift;
    case 'info': return LucideIcons.info;
    case 'award': return LucideIcons.award;
    case 'megaphone': return LucideIcons.megaphone;
    case 'shield': return LucideIcons.shield;
    default: return LucideIcons.star;
  }
}

  Widget _buildPremiumPromo(BuildContext context, bool isPremium) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PremiumScreen())),
      child: GlassCard(
        padding: const EdgeInsets.all(24),
        gradientColors: [
          AppColors.accent.withValues(alpha: 0.2),
          AppColors.accent.withValues(alpha: 0.05),
        ],
        borderColor: AppColors.accent.withValues(alpha: 0.3),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.crown, color: AppColors.accent, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Fayda Connect Pro',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isPremium ? 'Verified Professional Access' : 'Professional Identity Support',
                    style: const TextStyle(
                      color: AppColors.textMain,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isPremium ? 'Exclusive member tools active.' : 'Get official identity guidance.',
                    style: TextStyle(
                      color: AppColors.textMain.withValues(alpha: 0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, color: AppColors.accent, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedNews(BuildContext context, NewsItem latest, bool isPremium) {
    // Premium posts ALWAYS use the original accent/red theme
    final Color themeColor = latest.type == NewsType.premium ? AppColors.accent : (latest.type == NewsType.alert ? AppColors.error : AppColors.primary);
    final IconData themeIcon = latest.type == NewsType.premium ? LucideIcons.crown : (latest.type == NewsType.alert ? LucideIcons.alertCircle : LucideIcons.megaphone);
    final String label = latest.type == NewsType.premium ? 'PRO BROADCAST' : (latest.type == NewsType.alert ? 'SECURITY ALERT' : 'OFFICIAL FEED');

    return InkWell(
      onTap: () {
        if (latest.type == NewsType.premium) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const PremiumScreen()));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const NewsListScreen()));
        }
      },
      child: GlassCard(
        padding: const EdgeInsets.all(24),
        borderColor: themeColor.withValues(alpha: 0.3),
        gradientColors: [
          themeColor.withValues(alpha: 0.15),
          themeColor.withValues(alpha: 0.05),
        ],
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: themeColor.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(themeIcon, color: themeColor, size: 14),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: TextStyle(
                          color: themeColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                   ),
                  const SizedBox(height: 12),
                  Text(
                    latest.title,
                    style: const TextStyle(
                      color: AppColors.textMain,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    latest.content,
                    style: TextStyle(
                      color: AppColors.textMain.withValues(alpha: 0.7),
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(LucideIcons.chevronRight, color: themeColor, size: 18),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, ServiceCategory category) {
    if (category.id == 'banking') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const BankListScreen()));
    } else if (category.id == 'passport') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceListScreen(title: category.title, serviceProvider: passportServiceProvider)));
    } else if (category.id == 'business') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceListScreen(title: category.title, serviceProvider: businessServiceProvider)));
    } else if (category.id == 'education') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceListScreen(title: category.title, serviceProvider: educationServiceProvider)));
    } else if (category.id == 'public') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceListScreen(title: category.title, serviceProvider: publicServiceServiceProvider)));
    } else if (category.id == 'telecom') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceListScreen(title: category.title, serviceProvider: telecomServiceProvider)));
    }
  }

  String _getGreetingPrefix(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.amharic: return 'ሰላም';
      case AppLanguage.oromiffa: return 'Akkam';
      case AppLanguage.tigrigna: return 'ሰላም';
      default: return 'Hello';
    }
  }

  String _getAppName(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.amharic: return 'ፋይዳ ኮኔክት';
      case AppLanguage.oromiffa: return 'Fayda Connect';
      case AppLanguage.tigrigna: return 'ፋይዳ ኮኔክት';
      default: return 'Fayda Connect';
    }
  }
}

class _MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          Scaffold.of(context).openDrawer();
        },
        child: GlassCard(
          padding: const EdgeInsets.all(12),
          borderRadius: 14,
          child: const Icon(LucideIcons.menu, color: AppColors.primary, size: 24),
        ),
      ),
    );
  }
}

class _LanguageToggle extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(languageProvider);

    return PopupMenuButton<AppLanguage>(
      offset: const Offset(0, 50),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onSelected: (AppLanguage lang) {
        ref.read(languageProvider.notifier).state = lang;
        CustomSnackBar.show(context, message: 'Language changed to ${lang.name}');
      },
      itemBuilder: (context) => AppLanguage.values.map((lang) {
        return PopupMenuItem(
          value: lang,
          child: Row(
            children: [
              Text(
                lang.code,
                style: TextStyle(
                  color: currentLang == lang ? AppColors.primary : AppColors.textMain,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                lang.name,
                style: TextStyle(
                  color: currentLang == lang ? AppColors.primary : AppColors.textMain,
                  fontWeight: currentLang == lang ? FontWeight.w900 : FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        borderRadius: 14,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.languages, size: 24, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              currentLang.code,
              style: const TextStyle(color: AppColors.textMain, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            const Icon(LucideIcons.chevronDown, size: 16, color: AppColors.textDim),
          ],
        ),
      ),
    );
  }
}

class _PartnerCard extends StatelessWidget {
  final String title;
  final String desc;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  final bool isHorizontal;

  const _PartnerCard({
    required this.title, 
    required this.desc, 
    required this.color, 
    required this.icon, 
    required this.onTap,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    // If Horizontal (Single Item), act like a Banner
    if (isHorizontal) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: GlassCard(
          width: double.infinity, // Full Width
          padding: const EdgeInsets.all(24),
          borderRadius: 24,
          borderColor: color.withValues(alpha: 0.3),
          gradientColors: [
             color.withValues(alpha: 0.15),
             color.withValues(alpha: 0.05),
          ],
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                         Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(icon, color: color, size: 18),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "PARTNER OFFER",
                          style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textMain,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: TextStyle(
                         color: AppColors.textMain.withValues(alpha: 0.7),
                         fontSize: 13, 
                         height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Large Icon on the right for style
              Opacity(
                opacity: 0.2,
                child: Icon(icon, size: 60, color: color),
              ),
            ],
          ),
        ),
      );
    }

    final double cardHeight = context.responsive.isSmallPhone ? 200 : 220;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: GlassCard(
        width: context.responsive.cardWidth * 0.85,
        height: cardHeight,
        padding: EdgeInsets.zero,
        borderRadius: 24,
        borderColor: color.withValues(alpha: 0.3),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Faded Background Icon for "Pro" feel
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  icon,
                  size: 120,
                  color: color.withValues(alpha: 0.05),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
                          ),
                          child: Icon(icon, color: color, size: 24),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: color.withValues(alpha: 0.2)),
                          ),
                          child: Text(
                            "PARTNER",
                            style: TextStyle(
                              color: color,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textMain,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        desc,
                        style: TextStyle(
                          color: AppColors.textMain.withValues(alpha: 0.7),
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          'Claim Offer',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(LucideIcons.arrowRight, size: 14, color: color),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlurBlob extends StatelessWidget {
  final Color color;
  final double size;
  const _BlurBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final OrderStatus status;
  const _StatusIndicator({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey;
    switch (status) {
      case OrderStatus.pending: color = Colors.orange; break;
      case OrderStatus.processing: color = Colors.blue; break;
      case OrderStatus.completed: color = Colors.green; break;
      case OrderStatus.actionRequired: color = Colors.red; break;
    }

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 4, spreadRadius: 1),
        ],
        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
      ),
    );
  }
}

class _IdentityPlaceholder extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => ref.read(showLoginProvider.notifier).state = true,
      child: GlassCard(
      borderColor: Colors.orange.withValues(alpha: 0.3),
      gradientColors: [
        Colors.orange.withValues(alpha: 0.1),
        Colors.orange.withValues(alpha: 0.05),
      ],
      child: const Row(
        children: [
          Icon(LucideIcons.alertTriangle, color: Colors.orange),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Identity Not Linked',
                  style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Connect your Fayda ID to unlock all services.',
                  style: TextStyle(color: AppColors.textDim, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(LucideIcons.arrowRight, color: Colors.orange, size: 20),
        ],
      ),
    ));
  }
}

class _NotificationBell extends ConsumerWidget {
  final WidgetRef ref;
  const _NotificationBell({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch both News and Notifications
    final notifications = ref.watch(notificationsProvider);
    final newsUnread = ref.watch(unreadNewsCountProvider);
    final unreadCount = notifications.where((n) => !n.isRead).length + newsUnread;

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
      },
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GlassCard(
            padding: const EdgeInsets.all(12),
            borderRadius: 14,
            child: const Icon(
              LucideIcons.bell, 
              color: AppColors.textMain, 
              size: 24,
            ),
          ),
          if (unreadCount > 0)
            Positioned(
              top: -6,
              right: -6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Text(
                  unreadCount > 9 ? '9+' : unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BenefitsCarousel extends StatefulWidget {
  final List<PartnerBenefit> benefits;
  const _BenefitsCarousel({required this.benefits});

  @override
  State<_BenefitsCarousel> createState() => _BenefitsCarouselState();
}

class _BenefitsCarouselState extends State<_BenefitsCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180, // Fixed height for the banner style
          child: PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.benefits.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              final benefit = widget.benefits[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: context.responsive.horizontalPadding),
                child: _PartnerCard(
                  title: benefit.title,
                  desc: benefit.description,
                  color: Color(benefit.colorHex),
                  icon: _getIconFromName(benefit.iconName),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PartnerOfferScreen(benefit: benefit)));
                  },
                  isHorizontal: true, // Always Horizontal Banner
                ),
              );
            },
          ),
        ),
        
        if (widget.benefits.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.benefits.length, (index) {
              final isActive = _currentIndex == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 4,
                width: isActive ? 24 : 8, // "..." Effect
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.textDim.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
  IconData _getIconFromName(String name) {
    switch (name) {
      case 'percent': return LucideIcons.percent;
      case 'trendingDown': return LucideIcons.trendingDown;
      case 'gift': return LucideIcons.gift;
      case 'info': return LucideIcons.info;
      case 'award': return LucideIcons.award;
      case 'megaphone': return LucideIcons.megaphone;
      case 'shield': return LucideIcons.shield;
      default: return LucideIcons.star;
    }
  }
}

class _SearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
      },
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        borderRadius: 14,
        child: const Icon(LucideIcons.search, color: AppColors.primary, size: 24),
      ),
    );
  }
}
