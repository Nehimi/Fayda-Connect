import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';
import '../widgets/custom_snackbar.dart';
import 'package:flutter/services.dart';

class ReferralScreen extends ConsumerWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final referralCode = 'FAYDA-2026-XT';

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text(L10n.get(lang, 'referral_program')),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(LucideIcons.gift, color: AppColors.primary, size: 80),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                L10n.get(lang, 'referral_program'),
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textMain, letterSpacing: -1),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                L10n.get(lang, 'referral_desc'),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textDim, fontSize: 16),
              ),
            ),
            const SizedBox(height: 40),
            
            // Referral Code Card
            GlassCard(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const Text('YOUR REFERRAL CODE', style: TextStyle(color: AppColors.textDim, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          referralCode,
                          style: const TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(LucideIcons.copy, color: AppColors.primary),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: referralCode));
                            CustomSnackBar.show(context, message: 'Code copied to clipboard!');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Rewards Section
            const Text(
              'HOW IT WORKS',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2),
            ),
            const SizedBox(height: 16),
            _buildStepItem(LucideIcons.share2, 'Share your code', 'Invite friends to download Fayda-Connect.'),
            _buildStepItem(LucideIcons.userPlus, 'Friend Registers', 'They complete their first Fayda sync.'),
            _buildStepItem(LucideIcons.smartphone, 'Earn Rewards', 'Get Priority Credits per referral!'),
            
            const SizedBox(height: 40),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 64),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              onPressed: () {
                CustomSnackBar.show(context, message: 'Sharing link generated!');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.send),
                  SizedBox(width: 12),
                  Text('INVITE FRIENDS NOW', style: TextStyle(fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 16)),
                Text(desc, style: const TextStyle(color: AppColors.textDim, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
