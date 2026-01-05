
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/custom_snackbar.dart';

class ScannerResultScreen extends StatelessWidget {
  final Map<String, String> scannedData;

  const ScannerResultScreen({super.key, required this.scannedData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text('Scan Result'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(LucideIcons.checkCircle2, color: AppColors.success, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Identity Verified',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textMain),
            ),
            const SizedBox(height: 8),
            const Text(
              'We successfully extracted the following details from the card.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textDim),
            ),
            const SizedBox(height: 32),
            GlassCard(
               padding: const EdgeInsets.all(24),
               child: Column(
                 children: scannedData.entries.map((entry) {
                   return Padding(
                     padding: const EdgeInsets.only(bottom: 16),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text(
                           entry.key,
                           style: const TextStyle(color: AppColors.textDim, fontSize: 14),
                         ),
                         Text(
                           entry.value,
                           style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.w600, fontSize: 16),
                         ),
                       ],
                     ),
                   );
                 }).toList(),
               ),
            ),
            const SizedBox(height: 48),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.glassBorder),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Rescan', style: TextStyle(color: AppColors.textMain)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      CustomSnackBar.show(context, message: 'Data saved to Vault!');
                      Navigator.pop(context); // Go back to scanner
                      Navigator.pop(context); // Go back to home
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Save & Use', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
