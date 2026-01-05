import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';
import '../widgets/custom_snackbar.dart';

class AgentModeScreen extends ConsumerWidget {
  const AgentModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text(L10n.get(lang, 'agent_mode')),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      L10n.get(lang, 'agent_mode'),
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textMain, letterSpacing: -1),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      L10n.get(lang, 'agent_desc'),
                      style: const TextStyle(color: AppColors.textDim, fontSize: 14),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                  ),
                  child: const Text('ACTIVE', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildWalletCard(),
            const SizedBox(height: 32),
            const Text(
              'QUICK ACTIONS',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    icon: LucideIcons.userPlus,
                    label: 'Register New',
                    onTap: () {
                      CustomSnackBar.show(context, message: 'Opening Registration Form...');
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ActionCard(
                    icon: LucideIcons.history,
                    label: 'My Referrals',
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'RECENT COMMISSIONS',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2),
            ),
            const SizedBox(height: 16),
            _buildCommissionItem('SIM Registration - Kebede T.', '+10.00 ETB', '2 hours ago'),
            _buildCommissionItem('Bank Linking - Marta A.', '+25.00 ETB', '5 hours ago'),
            _buildCommissionItem('Passport Assist - Dawit G.', '+50.00 ETB', 'Yesterday'),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard() {
    return GlassCard(
      padding: const EdgeInsets.all(28),
      gradientColors: [
        AppColors.primary.withValues(alpha: 0.2),
        AppColors.primary.withValues(alpha: 0.05),
      ],
      child: Column(
        children: [
          const Text('Total Commission Earned', style: TextStyle(color: AppColors.textDim, fontSize: 14)),
          const SizedBox(height: 8),
          const Text('1,250.00 ETB', style: TextStyle(color: AppColors.textMain, fontSize: 36, fontWeight: FontWeight.w900)),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () {},
            child: const Text('Withdraw to Telebirr', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  Widget _buildCommissionItem(String title, String amount, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: const Icon(LucideIcons.trendingUp, color: AppColors.success, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(time, style: const TextStyle(color: AppColors.textDim, fontSize: 12)),
                ],
              ),
            ),
            Text(amount, style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w900, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionCard({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
