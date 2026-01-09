import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/app_drawer.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends ConsumerWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text(L10n.get(lang, 'help')),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildContactCard(lang),
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                L10n.get(lang, 'faq'),
                style: const TextStyle(color: AppColors.textMain, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            _buildFaqItem('What is Fayda ID?', 'Fayda is Ethiopia\'s national digital identity system used for banking, telecom, and government services.'),
            _buildFaqItem('Is my data secure?', 'Yes, Fayda Connect uses military-grade encryption to store your FIN details locally on your device.'),
            _buildFaqItem('How do I contact support?', 'You can reach us via Telegram or Email using the buttons above.'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(AppLanguage lang) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      gradientColors: [AppColors.primary.withValues(alpha: 0.1), AppColors.primary.withValues(alpha: 0.05)],
      child: Column(
        children: [
          Text(
            L10n.get(lang, 'how_help'),
            style: const TextStyle(color: AppColors.textMain, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildContactButton(LucideIcons.send, 'Telegram', const Color(0xFF0088cc), 'https://t.me/NehimiG2'),
              const SizedBox(width: 16),
              _buildContactButton(LucideIcons.mail, 'Email', AppColors.primary, 'mailto:faydaconnect@gmail.com'),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'faydaconnect@gmail.com',
            style: const TextStyle(
              color: AppColors.textDim,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton(IconData icon, String label, Color color, String url) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question, style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(answer, style: const TextStyle(color: AppColors.textDim, fontSize: 13, height: 1.5)),
          ],
        ),
      ),
    );
  }
}
