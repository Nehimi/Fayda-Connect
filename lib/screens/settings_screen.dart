import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/app_drawer.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_edit_screen.dart';
import '../widgets/custom_snackbar.dart';
import '../utils/database_seeder.dart';


class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final isTablet = width >= 600;
    final horizontalPadding = isTablet ? 32.0 : 24.0;
    final verticalPadding = isTablet ? 28.0 : 24.0;
    final cardPadding = EdgeInsets.all(isTablet ? 20 : 16);
    final itemSpacing = isTablet ? 16.0 : 12.0;
    final sectionSpacing = isTablet ? 36.0 : 32.0;
    return Scaffold(
      backgroundColor: AppColors.scaffoldFor(context),
      appBar: AppBar(
        title: Text(L10n.get(lang, 'settings')),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        children: [
          _buildSection(L10n.get(lang, 'account')),
          _buildSettingItem(
            context,
            ref,
            LucideIcons.user,
            L10n.get(lang, 'prof_info'),
            L10n.get(lang, 'prof_sub'),
            cardPadding: cardPadding,
            itemSpacing: itemSpacing,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileEditScreen()),
              );
            },
          ),

          _buildSettingItem(context, ref, LucideIcons.lock, L10n.get(lang, 'security'), L10n.get(lang, 'sec_sub'), cardPadding: cardPadding, itemSpacing: itemSpacing),
          
          SizedBox(height: sectionSpacing),
          _buildSection(L10n.get(lang, 'preferences')),
          _buildSettingItem(
            context,
            ref,
            LucideIcons.languages,
            L10n.get(lang, 'language'),
            L10n.get(lang, 'lang_sub'),
            cardPadding: cardPadding,
            itemSpacing: itemSpacing,
            onTap: () => _showLanguageDialog(context, ref),
          ),
          _buildSettingItem(context, ref, LucideIcons.bell, L10n.get(lang, 'notifications'), L10n.get(lang, 'notif_sub'), cardPadding: cardPadding, itemSpacing: itemSpacing),
          
          SizedBox(height: sectionSpacing),
          _buildSection(L10n.get(lang, 'application')),
          _buildSettingItem(
            context,
            ref,
            LucideIcons.info,
            L10n.get(lang, 'about_app'),
            L10n.get(lang, 'ver_sub'),
            cardPadding: cardPadding,
            itemSpacing: itemSpacing,
            onTap: () => _showAboutDialog(context),
          ),
          _buildSettingItem(
            context,
            ref,
            LucideIcons.shield,
            L10n.get(lang, 'privacy'),
            L10n.get(lang, 'priv_sub'),
            cardPadding: cardPadding,
            itemSpacing: itemSpacing,
            onTap: () => _showPrivacyDialog(context),
          ),


          _buildSection(lang == AppLanguage.english ? 'Safety & Support' : 'ደህንነት እና ድጋፍ'),
          _buildSettingItem(
            context,
            ref,
            LucideIcons.alertCircle,
            L10n.get(lang, 'emergency_qr'),
            L10n.get(lang, 'emergency_desc'),
            color: Colors.redAccent,
            cardPadding: cardPadding,
            itemSpacing: itemSpacing,
            onTap: () => _showEmergencyQR(context),
          ),

          if (true) ...[ // Always show for now, or hide behind a flag
            SizedBox(height: sectionSpacing),
            _buildSection('Developer Options'),
            _buildSettingItem(
              context,
              ref,
              LucideIcons.database,
              'Seed Database',
              'Reset/Populate default services to Firebase',
              cardPadding: cardPadding,
              itemSpacing: itemSpacing,
              onTap: () => _handleSeedDatabase(context),
            ),
          ],


        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, WidgetRef ref, IconData icon, String title, String subtitle, {Color? color, VoidCallback? onTap, required EdgeInsets cardPadding, required double itemSpacing}) {
    final brightness = Theme.of(context).brightness;
    return Padding(
      padding: EdgeInsets.only(bottom: itemSpacing),
      child: GlassCard(
        padding: cardPadding,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Row(
            children: [
              Icon(icon, color: color ?? AppColors.textMainFor(context), size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: color ?? AppColors.textMainFor(context), fontWeight: FontWeight.w600, fontSize: 16)),
                    Text(subtitle, style: TextStyle(color: AppColors.textDimFor(context), fontSize: 12)),
                  ],
                ),
              ),
              Icon(LucideIcons.chevronRight, color: AppColors.textDimFor(context), size: 18),
            ],
          ),
        ),
      ),
    );
  }



  void _showEmergencyQR(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: GlassCard(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('EMERGENCY IDENTITY', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 2)),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                  child: const Icon(LucideIcons.qrCode, size: 200, color: Colors.black),
                ),
                const SizedBox(height: 24),
                const Text('ABEBE BIKILA', style: TextStyle(color: AppColors.textMain, fontSize: 24, fontWeight: FontWeight.bold)),
                const Text('BLOOD TYPE: A+', style: TextStyle(color: AppColors.textDim, fontSize: 16)),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 56)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CLOSE'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select Language', style: TextStyle(color: AppColors.textMain, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...AppLanguage.values.map((lang) => ListTile(
              title: Text(lang.name, style: const TextStyle(color: AppColors.textMain)),
              onTap: () {
                ref.read(languageProvider.notifier).setLanguage(lang);
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardSurface,
        title: const Text('About Fayda Connect', style: TextStyle(color: AppColors.textMain)),
        content: const Text(
          'Fayda Connect is your gateway to digital identity and services in Ethiopia. \n\nVersion: 1.0.4 Activation',
          style: TextStyle(color: AppColors.textDim),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardSurface,
        title: const Text('Privacy Policy', style: TextStyle(color: AppColors.textMain)),
        content: const SingleChildScrollView(
          child: Text(
            'Your privacy is critical to us. We store your data locally on your device and encrypt sensitive information such as your FIN and banking details.\n\nWe do not share your personal data with third parties without your explicit consent.',
            style: TextStyle(color: AppColors.textDim),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('I Understand', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Future<void> _launchTelegram() async {
    final Uri url = Uri.parse('https://t.me/NehimiG2');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch \$url'); 
    }
  }

  Future<void> _handleSeedDatabase(BuildContext context) async {
    try {
      CustomSnackBar.show(context, message: 'Seeding database... please wait.', isError: false);
      await DatabaseSeeder.seedServices();
      if (context.mounted) {
        CustomSnackBar.show(context, message: 'Database seeded successfully!');
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.show(context, message: 'Seeding failed: $e', isError: true);
      }
    }
  }
}
