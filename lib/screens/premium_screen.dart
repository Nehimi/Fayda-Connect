import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/app_drawer.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PremiumScreen extends ConsumerWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(L10n.get(lang, 'pro')),
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(LucideIcons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Header Illustration/Icon
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.meshGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Icon(LucideIcons.crown, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 40),
            const Text(
              'Go Premium',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppColors.textMain,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'One subscription for all your digital identity needs in Ethiopia.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textDim, fontSize: 16),
            ),
            const SizedBox(height: 48),

            // Feature List
            _buildFeature(LucideIcons.zap, 'Zero Processing Fees', 'Skip the 50 ETB fee for individual bank linkings.'),
            _buildFeature(LucideIcons.headphones, 'Priority Concierge', 'Direct access to an agent via Telegram for complex issues.'),
            _buildFeature(LucideIcons.shieldCheck, 'Verified ID Vault', 'Advanced encryption for storing multiple family IDs.'),
            _buildFeature(LucideIcons.bellRing, 'Renewal Alerts', 'Get SMS alerts before your Passport or SIM expires.'),

            const SizedBox(height: 48),

            // Pricing Card
            GlassCard(
              padding: const EdgeInsets.all(32),
              borderColor: AppColors.primary.withValues(alpha: 0.5),
              child: Column(
                children: [
                  const Text(
                    'ANNUAL PLAN',
                    style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ETB ', style: TextStyle(fontSize: 18, color: AppColors.textMain, fontWeight: FontWeight.bold, height: 2)),
                      Text('499', style: TextStyle(fontSize: 48, color: AppColors.textMain, fontWeight: FontWeight.w900, letterSpacing: -2)),
                      Text('/yr', style: TextStyle(fontSize: 16, color: AppColors.textDim, height: 3)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 64),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      // Navigate to payment
                    },
                    child: const Text('Unlock Everything', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textMain)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppColors.textDim, fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
