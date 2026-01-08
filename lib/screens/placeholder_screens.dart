import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';
import 'profile_edit_screen.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                L10n.get(lang, 'id_vault'),
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.textMain, letterSpacing: -1),
              ),
              const SizedBox(height: 8),
              Text(
                L10n.get(lang, 'vault_desc'),
                style: const TextStyle(color: AppColors.textDim, fontSize: 16),
              ),
              const SizedBox(height: 48),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.wallet, size: 64, color: AppColors.primary),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Sync Vault Ready',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textMain),
                      ),
                      const SizedBox(height: 12),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Your administrative roadmap and synced identity status will appear here as you interact with services.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textDim, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final appUser = ref.watch(userProvider);
    final authUser = ref.watch(authServiceProvider).currentUser;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.meshGradient,
                        boxShadow: [
                          BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8)),
                        ],
                      ),
                      child: const Center(
                        child: Icon(LucideIcons.user, color: Colors.white, size: 60),
                      ),
                    ),
                    if (appUser.isPremium)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.crown, color: Colors.black, size: 16),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                appUser.name,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textMain, letterSpacing: -0.5),
              ),
              const SizedBox(height: 4),
              Text(
                authUser?.email ?? '',
                style: const TextStyle(color: AppColors.textDim, fontSize: 14),
              ),
              const SizedBox(height: 32),
              if (appUser.isPremium)
                GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  borderColor: Colors.amber.withValues(alpha: 0.3),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.shieldCheck, color: Colors.amber, size: 24),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Verified Professional Access',
                          style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(8)),
                        child: const Text('PRO', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 40),
              _buildProfileOption(
                icon: LucideIcons.settings,
                title: L10n.get(lang, 'prof_info'),
                subtitle: L10n.get(lang, 'prof_sub'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileEditScreen())),
              ),
              _buildProfileOption(
                icon: LucideIcons.helpCircle,
                title: L10n.get(lang, 'help'),
                subtitle: 'FAQ and Customer Support',
                onTap: () {}, // Already handled in Drawer, but nice here too
              ),
              const SizedBox(height: 40),
              TextButton.icon(
                onPressed: () => ref.read(authServiceProvider).signOut(),
                icon: const Icon(LucideIcons.logOut, color: Colors.redAccent),
                label: Text(
                  L10n.get(lang, 'sign_out'),
                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 100), // Space for nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: onTap,
        child: GlassCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(color: AppColors.textDim, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, color: AppColors.textDim, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
