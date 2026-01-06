import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
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
              'Premium Pass',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppColors.textMain,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Get direct access to expert assistance and advanced identity management tools.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textDim, fontSize: 16),
            ),
            const SizedBox(height: 40),

            const SizedBox(height: 20),


            // Feature List
            _buildFeature(LucideIcons.zap, 'Zero Processing Fees', 'Skip separate processing requests for individual bank linkings.'),
            _buildFeature(LucideIcons.headphones, 'Priority Concierge', 'Direct access to an agent via Telegram for complex issues.'),
            _buildFeature(LucideIcons.shieldCheck, 'Verified ID Vault', 'Advanced encryption for storing multiple family IDs.'),
            _buildFeature(LucideIcons.bellRing, 'Renewal Alerts', 'Get SMS alerts before your Passport or SIM expires.'),

            const SizedBox(height: 48),

            GlassCard(
              padding: const EdgeInsets.all(32),
              borderColor: AppColors.primary.withValues(alpha: 0.5),
              child: Column(
                children: [
                   const Text(
                    'SERVICE ACCESS',
                    style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Full Support & Features',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, color: AppColors.textMain, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Contact our support team to activate premium features and priority services.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textDim, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 64),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      shadowColor: AppColors.primary.withOpacity(0.4),
                      elevation: 10,
                    ),
                    onPressed: () async {
                      final url = Uri.parse('https://t.me/NehimiG2');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      }
                    },
                    icon: const Icon(LucideIcons.send),
                    label: const Text('Contact Support (@NehimiG2)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
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
