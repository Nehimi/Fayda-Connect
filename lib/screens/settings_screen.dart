import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/app_drawer.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text(L10n.get(lang, 'settings')),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSection(L10n.get(lang, 'account')),
          _buildSettingItem(LucideIcons.user, L10n.get(lang, 'prof_info'), L10n.get(lang, 'prof_sub')),
          _buildSettingItem(LucideIcons.lock, L10n.get(lang, 'security'), L10n.get(lang, 'sec_sub')),
          
          const SizedBox(height: 32),
          _buildSection(L10n.get(lang, 'preferences')),
          _buildSettingItem(LucideIcons.languages, L10n.get(lang, 'language'), L10n.get(lang, 'lang_sub')),
          _buildSettingItem(LucideIcons.bell, L10n.get(lang, 'notifications'), L10n.get(lang, 'notif_sub')),
          
          const SizedBox(height: 32),
          _buildSection(L10n.get(lang, 'application')),
          _buildSettingItem(LucideIcons.info, L10n.get(lang, 'about_app'), L10n.get(lang, 'ver_sub')),
          _buildSettingItem(LucideIcons.shield, L10n.get(lang, 'privacy'), L10n.get(lang, 'priv_sub')),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textMain, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.w600, fontSize: 16)),
                  Text(subtitle, style: const TextStyle(color: AppColors.textDim, fontSize: 12)),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, color: AppColors.textDim, size: 18),
          ],
        ),
      ),
    );
  }
}
