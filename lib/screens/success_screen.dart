import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';

class SuccessScreen extends ConsumerWidget {
  final String bankName;
  const SuccessScreen({super.key, required this.bankName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: Stack(
        children: [
          // Decorative background element
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.success.withOpacity(0.1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.checkCircle,
                    color: AppColors.success,
                    size: 100,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  L10n.get(lang, 'confirmed'),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textMain,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  lang == AppLanguage.english 
                    ? 'Expert assistance for $bankName has been initiated. Our team will contact you shortly.'
                    : 'ለ $bankName የባለሙያ እርዳታ ተጀምሯል። ቡድናችን በቅርቡ ያነጋግርዎታል።',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: AppColors.textDim, height: 1.5),
                ),
                const SizedBox(height: 48),
                GlassCard(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        L10n.get(lang, 'next_steps'),
                        style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.textMain, fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      _buildStep(LucideIcons.smartphone, 
                        lang == AppLanguage.english ? 'Keep your phone nearby for OTP verification.' : 'ለልዩ የይለፍ ቃል (OTP) ማረጋገጫ ስልክዎን አጠገብዎ ያድርጉ።'),
                      _buildStep(LucideIcons.bell, 
                        lang == AppLanguage.english ? 'Real-time status updates will be sent via SMS.' : 'የአሁናዊ የሁኔታ ዝመናዎች በኤስኤምኤስ (SMS) ይላካሉ።'),
                      _buildStep(LucideIcons.clock, 
                        lang == AppLanguage.english ? 'Estimated completion: 15-20 minutes.' : 'ግምታዊ የማጠናቀቂያ ጊዜ፡ ከ15-20 ደቂቃዎች።'),
                    ],
                  ),
                ),
                const SizedBox(height: 64),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 64),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                  child: Text(L10n.get(lang, 'back_workspace'), style: const TextStyle(fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: AppColors.textMain, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
