import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';
import '../widgets/custom_snackbar.dart';
import '../providers/user_provider.dart';

class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final user = FirebaseAuth.instance.currentUser;
    final appUser = ref.watch(userProvider);
    
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text('Member Activation'),
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
              child: const Icon(LucideIcons.shieldCheck, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 32),
            const Text(
              'Professional Access',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppColors.textMain,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Identity management tools and priority processing for registered organization members.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textDim, fontSize: 16),
            ),
            
            const SizedBox(height: 32),
            
            // ID Section hidden for "Pro" look - ID is handled background by requests

            const SizedBox(height: 40),

            // Feature List
            _buildFeature(LucideIcons.userPlus, 'Priority Account Sync', 'Direct assistance for banking and identity document synchronization.'),
            _buildFeature(LucideIcons.headphones, '24/7 Expert Concierge', 'Priority access to professional agents for case management.'),
            _buildFeature(LucideIcons.lock, 'Enterprise Identity Vault', 'Unlocks secure storage for multiple identity documents.'),
            _buildFeature(LucideIcons.bellRing, 'Smart Expiry Monitor', 'Automated reminders for important document renewals via Telegram/SMS.'),

            const SizedBox(height: 48),

            GlassCard(
              padding: const EdgeInsets.all(32),
              borderColor: AppColors.primary.withValues(alpha: 0.5),
              child: Column(
                children: [
                   const Text(
                    'MEMBERSHIP ACTIVATION',
                    style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Manual Verification',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, color: AppColors.textMain, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Access is granted by authorized administrators for registered members. Please contact activation support with your ID to verify your status.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textDim, fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 64),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      shadowColor: appUser.isPremium ? Colors.amber.withValues(alpha: 0.4) : AppColors.primary.withValues(alpha: 0.4),
                      elevation: 10,
                    ),
                    onPressed: appUser.isPremium ? null : () async {
                      // 1. Notify Admin via DB (Command Center)
                      if (user != null) {
                        try {
                          await FirebaseDatabase.instance.ref('premium_requests/${user.uid}').set({
                            'name': appUser.name,
                            'email': user.email,
                            'timestamp': ServerValue.timestamp,
                          });
                          if (context.mounted) {
                            CustomSnackBar.show(context, message: 'Activation request sent to admin!');
                          }
                        } catch (e) {
                           debugPrint("DB Sync Error: $e");
                        }
                      }

                      // 2. Launch Telegram for communication
                      final url = Uri.parse('https://t.me/NehimiG2');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      }
                    },
                    icon: Icon(appUser.isPremium ? LucideIcons.checkCircle : LucideIcons.userCheck),
                    label: Text(
                      appUser.isPremium ? 'Verified Professional' : 'Request Activation', 
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '* No direct payments are processed within this application.',
                    style: TextStyle(color: AppColors.textDim, fontSize: 10, fontStyle: FontStyle.italic),
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
