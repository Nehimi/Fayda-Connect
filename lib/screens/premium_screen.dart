import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/app_drawer.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'payment_screen.dart';

class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  bool isAnnual = true;

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text(L10n.get(lang, 'pro')),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 10),
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
              child: const Icon(LucideIcons.crown, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 32),
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
            const SizedBox(height: 40),

            // Plan Toggle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.glassSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _PlanTab('Monthly', !isAnnual, () => setState(() => isAnnual = false)),
                  _PlanTab('Yearly (Save 17%)', isAnnual, () => setState(() => isAnnual = true)),
                ],
              ),
            ),
            const SizedBox(height: 40),

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
                   Text(
                    isAnnual ? 'ANNUAL PLAN' : 'MONTHLY PLAN',
                    style: const TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('ETB ', style: TextStyle(fontSize: 18, color: AppColors.textMain, fontWeight: FontWeight.bold, height: 2)),
                      Text(isAnnual ? '499' : '50', style: const TextStyle(fontSize: 48, color: AppColors.textMain, fontWeight: FontWeight.w900, letterSpacing: -2)),
                      Text(isAnnual ? '/yr' : '/mo', style: const TextStyle(fontSize: 16, color: AppColors.textDim, height: 3)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 64),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      shadowColor: AppColors.primary.withOpacity(0.4),
                      elevation: 10,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                            bankName: isAnnual ? 'Premium (Yearly)' : 'Premium (Monthly)',
                          ),
                        ),
                      );
                    },
                    child: Text(isAnnual ? 'Save & Subscribe' : 'Subscribe Now', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
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

  Widget _PlanTab(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ] : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textDim,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
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
