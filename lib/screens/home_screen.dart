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
import 'news_list_screen.dart';
import 'partner_offer_screen.dart';

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
      body: Column(
        children: [
          // Fixed Header
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.responsive.horizontalPadding, 
              60, 
              context.responsive.horizontalPadding, 
              20
            ),
            child: Row(
              children: [
                _MenuButton(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      userAsync.when(
                        data: (user) => Text(
                          user != null 
                            ? '${_getGreetingPrefix(currentLang)}, ${user.displayName ?? 'User'}'
                            : _getGreetingPrefix(currentLang),
                          style: TextStyle(
                            color: AppColors.textDim,
                            fontSize: context.responsive.getFontSize(13),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        loading: () => Text('...', style: TextStyle(color: AppColors.textDim, fontSize: 13)),
                        error: (_, __) => Text(_getGreetingPrefix(currentLang), style: TextStyle(color: AppColors.textDim, fontSize: 13)),
                      ),
                      Text(
                        _getAppName(currentLang),
                        style: TextStyle(
                          color: AppColors.textMain,
                          fontSize: context.responsive.getFontSize(24),
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _NotificationBell(ref: ref),
                const SizedBox(width: 4),
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
                    horizontal: context.responsive.horizontalPadding, 
                    vertical: 8
                  ),
                  child: dynamicNews.when(
                    data: (news) {
                      // Only show PREMIUM posts in this banner
                      final latestPremium = news.where((n) => n.type == NewsType.premium).firstOrNull;
                      
                      if (latestPremium == null) {
                        return _buildPremiumPromo(context, isPremium);
                      }
                      return _buildFeaturedNews(context, latestPremium);
                    },
                    loading: () => _buildPremiumPromo(context, isPremium),
                    error: (_, __) => _buildPremiumPromo(context, isPremium),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.responsive.horizontalPadding, 
                    context.responsive.getSpacing(40), 
                    context.responsive.horizontalPadding, 
                    0
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
                        child: Text(
                          L10n.get(currentLang, 'view_all'), 
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: dynamicBenefits.when(
                  data: (benefits) {
                    if (benefits.isEmpty) {
                      return const SizedBox.shrink(); // Fallback if no dynamic content
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.responsive.horizontalPadding, 
                        vertical: 16
                      ),
                      child: Row(
                        children: benefits.map((benefit) => Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _PartnerCard(
                            title: benefit.title,
                            desc: benefit.description,
                            color: Color(benefit.colorHex),
                            icon: _getIconFromName(benefit.iconName),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PartnerOfferScreen(benefit: benefit)));
                            },
                          ),
                        )).toList(),
                      ),
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => const SizedBox.shrink(),
                ),
              ),




              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.responsive.horizontalPadding, 
                    context.responsive.getSpacing(40), 
                    context.responsive.horizontalPadding, 
                    16
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
                  horizontal: context.responsive.horizontalPadding
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
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          'Independent Service Provider',
                          style: TextStyle(color: AppColors.textDim, fontSize: 11),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Not affiliated with NID Ethiopia',
                          style: TextStyle(color: AppColors.textDim.withValues(alpha: 0.5), fontSize: 10),
                        ),
                        const SizedBox(height: 120),
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
    drawer: const AppDrawer(),
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
                    isPremium ? 'You are a Pro Member' : 'Unlimited Free Processing',
                    style: const TextStyle(
                      color: AppColors.textMain,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isPremium ? 'Enjoy all your exclusive benefits.' : 'Get year-round priority support.',
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

  Widget _buildFeaturedNews(BuildContext context, NewsUpdate latest) {
    // Premium posts ALWAYS use the original accent/red theme
    const Color themeColor = AppColors.accent;
    const IconData themeIcon = LucideIcons.crown;
    const String label = 'PRO BROADCAST';

    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PremiumScreen())),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        borderRadius: 12,
        child: Row(
          children: [
            const Icon(LucideIcons.languages, size: 16, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              currentLang.code,
              style: const TextStyle(color: AppColors.textMain, fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const Icon(LucideIcons.chevronDown, size: 14, color: AppColors.textDim),
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

  const _PartnerCard({required this.title, required this.desc, required this.color, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double cardHeight = context.responsive.isSmallPhone ? 280 : 300;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: GlassCard(
        width: context.responsive.cardWidth * 1.05,
        height: cardHeight,
        padding: EdgeInsets.zero,
        borderRadius: 28,
        borderColor: color.withValues(alpha: 0.3),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              // Faded Background Icon for "Pro" feel
              Positioned(
                right: -25,
                bottom: -25,
                child: Icon(
                  icon,
                  size: 160,
                  color: color.withValues(alpha: 0.05),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
                          ),
                          child: Icon(icon, color: color, size: 22),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'PARTNER',
                            style: TextStyle(
                              color: color.withValues(alpha: 0.8),
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.textMain,
                        fontWeight: FontWeight.w900,
                        fontSize: context.responsive.getFontSize(18),
                        letterSpacing: -0.5,
                        height: 1.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Text(
                        desc,
                        style: TextStyle(
                          color: AppColors.textMain.withValues(alpha: 0.6),
                          fontSize: context.responsive.getFontSize(13),
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                        maxLines: 4,
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

class _NotificationBell extends StatelessWidget {
  final WidgetRef ref;
  const _NotificationBell({required this.ref});

  @override
  Widget build(BuildContext context) {
    final newsCount = ref.watch(unreadNewsCountProvider);

    return InkWell(
      onTap: () {
        // Mark as seen immediately when clicking the bell
        final news = ref.read(newsProvider).value;
        if (news != null && news.isNotEmpty) {
          ref.read(newsSeenProvider.notifier).markAsSeen(news.first.id);
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) => const NewsListScreen()));
      },
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GlassCard(
            padding: const EdgeInsets.all(10),
            borderRadius: 12,
            child: Icon(
              LucideIcons.bell, 
              color: AppColors.textMain, 
              size: context.responsive.getIconSize(22)
            ),
          ),
          if (newsCount > 0)
            Positioned(
              top: -6,
              left: -6,
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
                  newsCount > 9 ? '9+' : newsCount.toString(),
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
