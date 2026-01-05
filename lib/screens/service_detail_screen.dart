import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/service_model.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'payment_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';

class ServiceDetailScreen extends ConsumerWidget {
  final GeneralService service;

  const ServiceDetailScreen({super.key, required this.service});

  Future<void> _launchUrl(GeneralService service) async {
    if (service.officialLink == null) return;
    final Uri url = Uri.parse(service.officialLink!);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
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
                      tag: service.id,
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
                          service.logo,
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => 
                            const Icon(LucideIcons.star, size: 100, color: AppColors.primary),
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
                  Text(
                    service.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textMain,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.description,
                    style: const TextStyle(color: AppColors.textDim, fontSize: 16, height: 1.4),
                  ),
                  const SizedBox(height: 32),
                  _SectionHeader(title: L10n.get(lang, 'what_need')),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: service.requirements.map((req) => _PremiumChip(label: L10n.getLocalized(lang, req))).toList(),
                  ),
                  const SizedBox(height: 40),
                  _SectionHeader(title: lang == AppLanguage.english ? 'Process Guide' : 'የሂደት መመሪያ'),
                  const SizedBox(height: 24),
                  ...service.instructionSteps.asMap().entries.map((entry) {
                    return _StepItem(
                      index: entry.key,
                      title: L10n.getLocalized(lang, entry.value),
                      isLast: entry.key == service.instructionSteps.length - 1,
                    );
                  }).toList(),
                  const SizedBox(height: 48),
                  if (service.officialLink != null)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 64),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () => _launchUrl(service),
                      child: Text(
                        lang == AppLanguage.english 
                          ? 'Visit Official ${service.category} Site' 
                          : 'ይፋዊ የ${service.category} ድረ-ገጽ ይጎብኙ', 
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  const SizedBox(height: 24),
                  _buildAssistanceCard(context, lang),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssistanceCard(BuildContext context, AppLanguage lang) {
    return GlassCard(
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
            lang == AppLanguage.english ? 'Need Expert Help?' : 'የባለሙያ እርዳታ ይፈልጋሉ?',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textMain),
          ),
          const SizedBox(height: 8),
          Text(
            lang == AppLanguage.english 
              ? 'Our certified experts can handle this entire application securely for you.'
              : 'የእኛ የተረጋገጡ ባለሙያዎች ይህንን አጠቃላይ ማመልከቻ ለእርስዎ ደህንነቱ በተጠበቀ ሁኔታ ማስተናገድ ይችላሉ።',
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentScreen(bankName: service.name)),
              );
            },
            child: Text(
              lang == AppLanguage.english 
                ? 'Pay ${service.assistanceFee.toStringAsFixed(0)} ETB & Start Now' 
                : '${service.assistanceFee.toStringAsFixed(0)} ብር ይክፈሉ እና አሁኑኑ ይጀምሩ', 
              style: const TextStyle(fontWeight: FontWeight.w800)),
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

class _StepItem extends StatelessWidget {
  final int index;
  final String title;
  final bool isLast;

  const _StepItem({required this.index, required this.title, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
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
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textMain,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
