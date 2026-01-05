import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/app_drawer.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/digital_id.dart';
import '../widgets/three_d_card.dart';

class VaultScreen extends ConsumerWidget {
  const VaultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    
    // Mock ID for demonstration
    final mockId = DigitalID(
      fullName: 'Abebe Bikila',
      fin: '1234 5678 9012',
      dob: '12 OCT 1990',
      gender: 'MALE',
      issueDate: '01 JAN 2024',
      expiryDate: '01 JAN 2034',
      photo: '',
    );

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text(L10n.get(lang, 'vault')),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Digital ID Vault',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textMain, letterSpacing: -1),
                    ),
                    Row(
                      children: [
                        const Icon(LucideIcons.wifiOff, size: 14, color: AppColors.success),
                        const SizedBox(width: 6),
                        Text(
                          'Offline Mode Active',
                          style: TextStyle(color: AppColors.success.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(LucideIcons.shieldCheck, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            ThreeDDigitalCard(id: mockId),
            
            const SizedBox(height: 32),
            
            Row(
              children: [
                Expanded(
                  child: _VaultAction(
                    icon: LucideIcons.qrCode,
                    label: 'Show QR',
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _VaultAction(
                    icon: LucideIcons.scan,
                    label: 'P2P Verify',
                    onTap: () => _showP2PScanner(context),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Security Details',
                style: TextStyle(color: AppColors.textMain, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            
            _SecurityItem(
              icon: LucideIcons.lock,
              title: 'On-Device Encryption',
              desc: 'Your FIN is stored in the Secure Enclave.',
            ),
            _SecurityItem(
              icon: LucideIcons.fingerprint,
              title: 'Biometric Locked',
              desc: 'FaceID/Fingerprint required for access.',
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showP2PScanner(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 32),
            const Text('P2P Verification', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textMain)),
            const SizedBox(height: 8),
            const Text('Scan another person\'s Fayda QR to verify identity', style: TextStyle(color: AppColors.textDim)),
            const Spacer(),
            // Mock Scanner UI
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                   Center(child: Icon(LucideIcons.scan, size: 100, color: AppColors.primary.withOpacity(0.2))),
                   const Align(
                     alignment: Alignment.topCenter,
                     child: Padding(
                       padding: EdgeInsets.only(top: 20),
                       child: Text('Align QR Code', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                     ),
                   ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 64),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel Scanning', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VaultAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _VaultAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _SecurityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _SecurityItem({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textDim, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(desc, style: const TextStyle(color: AppColors.textDim, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
