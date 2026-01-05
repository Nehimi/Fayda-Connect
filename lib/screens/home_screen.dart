import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/service_category.dart';
import '../theme/colors.dart';
import '../widgets/category_card.dart';
import '../widgets/glass_card.dart';
import 'bank_list_screen.dart';
import 'service_list_screen.dart';
import '../providers/service_provider.dart';
import '../providers/order_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeOrders = ref.watch(ordersProvider);
    
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hello, User',
                            style: TextStyle(
                              color: AppColors.textDim,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Fayda Connect',
                            style: TextStyle(
                              color: AppColors.textMain,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1,
                            ),
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
                  child: GlassCard(
                    padding: const EdgeInsets.all(24),
                    gradientColors: [
                      AppColors.primary.withValues(alpha: 0.2),
                      AppColors.primary.withValues(alpha: 0.05),
                    ],
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Secure ID Vault',
                                style: TextStyle(
                                  color: AppColors.textMain,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Coming Soon: Encrypt and store your Fayda FIN securely on your device.',
                                style: TextStyle(
                                  color: AppColors.textMain.withValues(alpha: 0.7),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: AppColors.textMain,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.lock, color: AppColors.primary, size: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 40, 24, 16),
                  child: Text(
                    'Explore Services',
                    style: TextStyle(
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
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
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
    }
  }
}

class _LanguageToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: 12,
      child: Row(
        children: [
          const Icon(LucideIcons.languages, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            'EN',
            style: TextStyle(color: AppColors.textMain, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Icon(LucideIcons.chevronDown, size: 14, color: AppColors.textDim),
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
