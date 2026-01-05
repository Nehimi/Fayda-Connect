import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/app_drawer.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VaultScreen extends ConsumerWidget {
  const VaultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(L10n.get(lang, 'vault')),
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
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
              child: const Icon(LucideIcons.shieldCheck, size: 80, color: AppColors.primary),
            ),
            const SizedBox(height: 40),
            const Text(
              'Your Digital Fortress',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textMain),
            ),
            const SizedBox(height: 12),
            const Text(
              'Securely store and share your Fayda ID details with end-to-end encryption.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textDim, fontSize: 16),
            ),
            const SizedBox(height: 48),
            
            // Empty State / Call to Action
            GlassCard(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const Icon(LucideIcons.plusCircle, size: 48, color: AppColors.textDim),
                  const SizedBox(height: 16),
                  const Text(
                    'No IDs Stored Yet',
                    style: TextStyle(color: AppColors.textMain, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Add My First ID', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Security Info
            Row(
              children: [
                const Icon(LucideIcons.lock, size: 16, color: AppColors.textDim),
                const SizedBox(width: 8),
                Text(
                  'AES-256 Bit Encryption Active',
                  style: TextStyle(color: AppColors.textDim.withValues(alpha: 0.7), fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
