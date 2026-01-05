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
import '../providers/service_provider.dart';
import '../providers/order_provider.dart';
import '../providers/language_provider.dart';
import '../providers/reminder_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeOrders = ref.watch(ordersProvider);
    final currentLang = ref.watch(languageProvider);
    final reminders = ref.watch(remindersProvider);
    
    final categories = [
      ServiceCategory(
        title: 'Banking',
        description: 'Link Fayda to your accounts',
        icon: LucideIcons.landmark,
        color: const Color(0xFF6366F1),
      ),
      ServiceCategory(
        title: 'Passport',
        description: 'New app & Expire renewal',
        icon: LucideIcons.contact,
        color: const Color(0xFF10B981),
      ),
      ServiceCategory(
        title: 'Business',
        description: 'TIN & Trade licensing',
        icon: LucideIcons.briefcase,
        color: const Color(0xFFF59E0B),
      ),
      ServiceCategory(
        title: 'Education',
        description: 'Exam & University link',
        icon: LucideIcons.graduationCap,
        color: const Color(0xFFEC4899),
      ),
      ServiceCategory(
        title: 'Public',
        description: 'Gov & Legal paperwork',
        icon: LucideIcons.shieldCheck,
        color: const Color(0xFF06B6D4),
      ),
      ServiceCategory(
        title: 'Telecom',
        description: 'SIM Card registration',
        icon: LucideIcons.smartphone,
        color: const Color(0xFF8B5CF6),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: Stack(
        children: [
          // Background mesh gradient blobs
          Positioned(
            top: -100,
            right: -100,
            child: _BlurBlob(color: AppColors.primary.withValues(alpha: 0.15), size: 400),
          ),
          Positioned(
            bottom: -50,
            left: -100,
            child: _BlurBlob(color: AppColors.secondary.withValues(alpha: 0.1), size: 300),
          ),
          
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 70, 24, 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _MenuButton(),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Text(
                                 _getGreeting(currentLang),
                                 style: const TextStyle(
                                   color: AppColors.textDim,
                                   fontSize: 14,
                                   fontWeight: FontWeight.w500,
                                 ),
                               ),
                               const SizedBox(height: 4),
                               Text(
                                 _getAppName(currentLang),
                                 style: const TextStyle(
                                   color: AppColors.textMain,
                                   fontSize: 28,
                                   fontWeight: FontWeight.w900,
                                   letterSpacing: -1,
                                 ),
                               ),
                             ],
                          ),
                        ],
                      ),
                      _LanguageToggle(),
                    ],
                  ),
                ),
              ),

              if (activeOrders.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Active Requests',
                          style: TextStyle(color: AppColors.textMain, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        ...activeOrders.map((order) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GlassCard(
                            padding: const EdgeInsets.all(16),
                            borderColor: AppColors.primary.withValues(alpha: 0.3),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(LucideIcons.clock, color: AppColors.primary, size: 20),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(order.serviceName, style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold)),
                                      Text(order.statusLabel, style: TextStyle(color: AppColors.primary.withValues(alpha: 0.8), fontSize: 12)),
                                    ],
                                  ),
                                ),
                                Text(
                                  DateFormat('HH:mm').format(order.orderDate),
                                  style: const TextStyle(color: AppColors.textDim, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        )).toList(),
                      ],
                    ),
                  ),
                ),
              
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: InkWell(
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
                                    Text(
                                      'Fayda Connect Pro',
                                      style: TextStyle(
                                        color: AppColors.accent.withValues(alpha: 0.9),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Unlimited Free Processing',
                                  style: TextStyle(
                                    color: AppColors.textMain,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Get annual concierge service for 499 ETB.',
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
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 40, 24, 0),
                  child: Text(
                    'Partner Benefits',
                    style: TextStyle(
                      color: AppColors.textMain,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      _PartnerCard(
                        title: 'Amole Special Offer',
                        desc: 'Get 5% Cashback on linking.',
                        color: const Color(0xFFF59E0B),
                        icon: LucideIcons.percent,
                      ),
                      const SizedBox(width: 16),
                      _PartnerCard(
                        title: 'CBE Low Interest',
                        desc: 'Apply with Fayda ID today.',
                        color: const Color(0xFF6366F1),
                        icon: LucideIcons.trendingDown,
                      ),
                    ],
                  ),
                ),
              ),

              if (reminders.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          L10n.get(currentLang, 'alerts'),
                          style: const TextStyle(color: AppColors.textMain, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        ...reminders.map((reminder) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GlassCard(
                            padding: const EdgeInsets.all(20),
                            gradientColors: [
                              reminder.color.withValues(alpha: 0.1),
                              reminder.color.withValues(alpha: 0.05),
                            ],
                            borderColor: reminder.color.withValues(alpha: 0.3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: reminder.color.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(reminder.icon, color: reminder.color, size: 24),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        L10n.getLocalized(currentLang, reminder.title),
                                        style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.w900, fontSize: 16),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        L10n.getLocalized(currentLang, reminder.description),
                                        style: TextStyle(color: AppColors.textMain.withValues(alpha: 0.7), fontSize: 13, height: 1.4),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )).toList(),
                      ],
                    ),
                  ),
                ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 40, 24, 16),
                  child: Text(
                    L10n.get(currentLang, 'explore'),
                    style: const TextStyle(
                      color: AppColors.textMain,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
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
        ],
      ),
      drawer: const AppDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 64,
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: () => _showScanDialog(context),
          child: Container(
            decoration: BoxDecoration(
              gradient: AppColors.meshGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.scanLine, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    L10n.get(currentLang, 'scan_id'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showScanDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final lang = ref.watch(languageProvider);
          return GlassCard(
            padding: const EdgeInsets.all(32),
            borderRadius: 30,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textDim.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.scanLine, color: AppColors.primary, size: 48),
                ),
                const SizedBox(height: 24),
                Text(
                  L10n.get(lang, 'ready_scan'),
                  style: const TextStyle(color: AppColors.textMain, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Point your camera at the Fayda QR code or FIN card to extract details automatically.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textDim, fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 64),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(L10n.get(lang, 'access_camera'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleNavigation(BuildContext context, ServiceCategory category) {
    if (category.title == 'Banking') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const BankListScreen()));
    } else if (category.title == 'Passport') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceListScreen(title: 'Passports', serviceProvider: passportServiceProvider)));
    } else if (category.title == 'Business') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceListScreen(title: 'Business', serviceProvider: businessServiceProvider)));
    } else if (category.title == 'Education') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceListScreen(title: 'Education', serviceProvider: educationServiceProvider)));
    } else if (category.title == 'Public') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceListScreen(title: 'Public Services', serviceProvider: publicServiceServiceProvider)));
    } else if (category.title == 'Telecom') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceListScreen(title: 'Telecom Services', serviceProvider: telecomServiceProvider)));
    }
  }

  String _getGreeting(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.amharic: return 'ሰላም፣ ተጠቃሚ';
      case AppLanguage.oromiffa: return 'Akkam, Fayyadamaa';
      case AppLanguage.tigrigna: return 'ሰላም፣ ተጠቃሚ';
      default: return 'Hello, User';
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Language changed to ${lang.name}'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.primary,
          ),
        );
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

  const _PartnerCard({required this.title, required this.desc, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.2), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(desc, style: TextStyle(color: AppColors.textMain.withValues(alpha: 0.7), fontSize: 13)),
        ],
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
