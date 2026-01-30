import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/bank_model.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'service_form_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';
import '../providers/user_provider.dart';
import '../providers/checklist_provider.dart';

class BankDetailScreen extends ConsumerWidget {
  final Bank bank;

  const BankDetailScreen({super.key, required this.bank});

  Future<void> _launchUrl(Bank bank) async {
    if (bank.officialLink == null) return;
    final Uri url = Uri.parse(bank.officialLink!);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final user = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: AppColors.meshGradient,
                    ),
                  ),
                  Center(
                    child: Hero(
                      tag: bank.id,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 30,
                            ),
                          ],
                        ),
                        child: Image.network(
                          bank.logo,
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(LucideIcons.landmark, color: AppColors.primary, size: 60),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bank.name,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textMain,
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              lang == AppLanguage.english 
                                ? 'Sync your Fayda ID with ${bank.name}'
                                : '${bank.name}ን ከፋይዳ መታወቂያዎ ጋር ያገናኙ',
                              style: const TextStyle(color: AppColors.textDim, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _SectionHeader(title: L10n.get(lang, 'what_need')),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: bank.requirements.map((req) => _PremiumChip(label: L10n.getLocalized(lang, req))).toList(),
                  ),
                  const SizedBox(height: 40),
                  _SectionHeader(title: L10n.get(lang, 'steps')),
                  const SizedBox(height: 12),
                  const SizedBox(height: 24),
                  ...bank.instructionSteps.asMap().entries.map((entry) {
                    return _StepItem(
                      serviceId: bank.id,
                      index: entry.key, 
                      title: L10n.getLocalized(lang, entry.value), 
                      isLast: entry.key == bank.instructionSteps.length - 1
                    );
                  }).toList(),
                  const SizedBox(height: 48),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 64),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () => _launchUrl(bank),
                    child: Text(L10n.get(lang, 'start_sync'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(height: 24),
                  if (user.isPremium)
                    GlassCard(
                      padding: const EdgeInsets.all(28),
                      borderColor: Colors.amber.withValues(alpha: 0.4),
                      gradientColors: [
                        Colors.amber.withValues(alpha: 0.15),
                        Colors.amber.withValues(alpha: 0.05),
                      ],
                      child: Column(
                        children: [
                          const Icon(LucideIcons.crown, color: Colors.amber, size: 32),
                          const SizedBox(height: 16),
                          const Text(
                            'Priority Guidance Active',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textMain),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            lang == AppLanguage.english
                                ? 'Exclusive Elite Support active. Our professionals handle your bank sync at no cost.'
                                : 'ልዩ የላቀ ድጋፍ ንቁ ነው። ባለሙያዎቻችን የባንክ ትስስርዎን ያለ ምንም ክፍያ ያስተናግዳሉ።',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textMain.withValues(alpha: 0.8), fontSize: 13, height: 1.5),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            onPressed: () async {
                              final url = Uri.parse('https://t.me/NehimiG2');
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url, mode: LaunchMode.externalApplication);
                              }
                            },
                            child: Text(
                              lang == AppLanguage.english ? 'Contact Agent (Free Support)' : 'ባለሙያ ያናግሩ (ነፃ ድጋፍ)',
                              style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    GlassCard(
                      padding: const EdgeInsets.all(28),
                      gradientColors: [
                        AppColors.accent.withValues(alpha: 0.1),
                        AppColors.accent.withValues(alpha: 0.05),
                      ],
                      borderColor: AppColors.accent.withValues(alpha: 0.3),
                      child: Column(
                        children: [
                          const Icon(LucideIcons.sparkles, color: AppColors.accent, size: 32),
                          const SizedBox(height: 16),
                          Text(
                            L10n.get(lang, 'skip_queue'),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textMain),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            L10n.get(lang, 'skip_desc'),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textMain.withValues(alpha: 0.7), fontSize: 13),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            onPressed: () async {
                              final url = Uri.parse('https://t.me/NehimiG2');
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url, mode: LaunchMode.externalApplication);
                              }
                            },
                            child: Text(
                              lang == AppLanguage.english
                                  ? 'Contact Support for Help'
                                  : 'ለመታገዝ ባለሙያ ያናግሩ',
                              style: const TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: AppColors.primary.withValues(alpha: 0.8),
        letterSpacing: 2,
      ),
    );
  }
}

class _PremiumChip extends StatelessWidget {
  final String label;
  const _PremiumChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Text(label, style: const TextStyle(color: AppColors.textMain, fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }
}

class _StepItem extends ConsumerWidget {
  final String serviceId;
  final int index;
  final String title;
  final bool isLast;

  const _StepItem({required this.serviceId, required this.index, required this.title, this.isLast = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCompleted = ref.watch(checklistProvider.notifier).isStepCompleted(serviceId, index);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => ref.read(checklistProvider.notifier).toggleStep(serviceId, index),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green : AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: isCompleted ? [BoxShadow(color: Colors.green.withValues(alpha: 0.3), blurRadius: 8)] : null,
                  ),
                  child: Center(
                    child: isCompleted 
                        ? const Icon(LucideIcons.check, color: Colors.white, size: 16)
                        : Text(
                            '${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: isCompleted 
                        ? Colors.green.withValues(alpha: 0.3)
                        : AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: GestureDetector(
              onTap: () => ref.read(checklistProvider.notifier).toggleStep(serviceId, index),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: isCompleted ? AppColors.textMain.withValues(alpha: 0.5) : AppColors.textMain,
                    fontWeight: isCompleted ? FontWeight.normal : FontWeight.w500,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

