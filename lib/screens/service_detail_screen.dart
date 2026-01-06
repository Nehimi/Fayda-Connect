import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/service_model.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'payment_screen.dart';
import 'service_form_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';
import '../providers/user_provider.dart';

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
                  const SizedBox(height: 12),
                  _VoiceGuide(steps: service.instructionSteps, lang: lang),
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
                  _buildAssistanceCard(context, lang, user.isPremium),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssistanceCard(BuildContext context, AppLanguage lang, bool isPremium) {
    if (isPremium) {
       return GlassCard(
        padding: const EdgeInsets.all(28),
        gradientColors: [
          Colors.amber.withValues(alpha: 0.1),
          Colors.amber.withValues(alpha: 0.05),
        ],
        borderColor: Colors.amber.withValues(alpha: 0.3),
        child: Column(
          children: [
            const Icon(LucideIcons.crown, color: Colors.amber, size: 32),
            const SizedBox(height: 16),
            const Text(
              'Premium Concierge Active',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textMain),
            ),
            const SizedBox(height: 8),
            Text(
              lang == AppLanguage.english
                  ? 'Your service fee is waived. Our experts will handle the process.'
                  : 'የአገልግሎት ክፍያዎ ቀርቷል። ባለሙያዎቻችን ሂደቱን ያስተናግዳሉ።',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMain.withValues(alpha: 0.7), fontSize: 13),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceFormScreen(
                      serviceName: service.name,
                      category: service.category,
                    ),
                  ),
                );
              },
              child: Text(
                lang == AppLanguage.english ? 'Start Application (Free)' : 'ማመልከቻ ይጀምሩ (ነጻ)',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      );
    }

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
                MaterialPageRoute(
                  builder: (context) => ServiceFormScreen(
                    serviceName: service.name,
                    category: service.category,
                  ),
                ),
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

class _VoiceGuide extends StatefulWidget {
  final List<String> steps;
  final AppLanguage lang;

  const _VoiceGuide({required this.steps, required this.lang});

  @override
  State<_VoiceGuide> createState() => _VoiceGuideState();
}

class _VoiceGuideState extends State<_VoiceGuide> with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  int _currentStepIndex = -1;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() async {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _currentStepIndex = 0;
        _controller.repeat(reverse: true);
        _playSequence();
      } else {
        _currentStepIndex = -1;
        _controller.stop();
      }
    });
  }

  void _playSequence() async {
    for (int i = 0; i < widget.steps.length; i++) {
      if (!_isPlaying) break;
      setState(() => _currentStepIndex = i);
      await Future.delayed(const Duration(seconds: 3));
    }
    if (mounted && _isPlaying) {
      setState(() {
        _isPlaying = false;
        _currentStepIndex = -1;
        _controller.stop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 16,
      borderColor: _isPlaying ? AppColors.primary.withValues(alpha: 0.5) : AppColors.glassBorder,
      child: Row(
        children: [
          GestureDetector(
            onTap: _togglePlay,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isPlaying ? AppColors.primary : AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? LucideIcons.pause : LucideIcons.play,
                color: _isPlaying ? Colors.white : AppColors.primary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10n.get(widget.lang, 'voice_guide'),
                  style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  _isPlaying 
                    ? L10n.getLocalized(widget.lang, widget.steps[_currentStepIndex])
                    : L10n.get(widget.lang, 'listen_instr'),
                  style: TextStyle(
                    color: _isPlaying ? AppColors.primary : AppColors.textDim, 
                    fontSize: 12,
                    fontWeight: _isPlaying ? FontWeight.bold : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (_isPlaying)
            Row(
              children: List.generate(5, (index) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    double value = (_controller.value + (index * 0.2)) % 1.0;
                    return Container(
                      width: 3,
                      height: 10 + (15 * (value > 0.5 ? 1.0 - value : value) * 2),
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  },
                );
              }),
            ),
        ],
      ),
    );
  }
}
