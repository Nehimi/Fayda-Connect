import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/service_model.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'service_form_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';
import '../providers/user_provider.dart';
import '../providers/checklist_provider.dart';

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
                  _ProgressHeader(serviceId: service.id, totalSteps: service.instructionSteps.length),
                  const SizedBox(height: 16),
                  _VoiceGuide(steps: service.instructionSteps, lang: lang),
                  const SizedBox(height: 24),
                  ...service.instructionSteps.asMap().entries.map((entry) {
                    return _StepItem(
                      serviceId: service.id,
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
              'Priority Guidance Active',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textMain),
            ),
            const SizedBox(height: 8),
            Text(
              lang == AppLanguage.english
                  ? 'Professional guidance included. We\'ll help you navigate the process.'
                  : 'የባለሙያ መመሪያ ተካቷል። ሂደቱን ለመምራት እንረዳዎታለን።',
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
              onPressed: () async {
                final url = Uri.parse('https://t.me/faydaconnectbot');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              child: Text(
                lang == AppLanguage.english ? 'Get Priority Support' : 'የቅድሚያ ድጋፍ ያግኙ',
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
            lang == AppLanguage.english ? 'Need Guidance?' : 'መመሪያ ይፈልጋሉ?',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textMain),
          ),
          const SizedBox(height: 8),
          Text(
            lang == AppLanguage.english 
              ? 'Get professional assistance to help you navigate your application securely.'
              : 'ማመልከቻዎን ደህንነቱ በተጠበቀ ሁኔታ ለመሙላት የባለሙያ እርዳታ ያግኙ።',
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
              final url = Uri.parse('https://t.me/faydaconnectbot');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
            child: Text(
              lang == AppLanguage.english 
                ? 'Connect with Support for Guidance' 
                : 'ድጋፍ ለማግኘት ያነጋግሩ', 
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

class _ProgressHeader extends ConsumerWidget {
  final String serviceId;
  final int totalSteps;
  const _ProgressHeader({required this.serviceId, required this.totalSteps});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(checklistProvider.notifier).getProgress(serviceId, totalSteps);
    final percentage = (progress * 100).toInt();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ROADMAP PROGRESS',
              style: TextStyle(color: AppColors.textDim, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
            Text(
              '$percentage%',
              style: TextStyle(color: progress == 1 ? Colors.green : AppColors.primary, fontWeight: FontWeight.w900, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(progress == 1 ? Colors.green : AppColors.primary),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

class _VoiceGuide extends StatefulWidget {
  final List<String> steps;
  final AppLanguage lang;

  const _VoiceGuide({
    required this.steps, 
    required this.lang,
  });

  @override
  State<_VoiceGuide> createState() => _VoiceGuideState();
}

class _VoiceGuideState extends State<_VoiceGuide> with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  int _currentStepIndex = -1;
  late AnimationController _controller;
  late FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _flutterTts = FlutterTts();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.awaitSpeakCompletion(true);
    await _flutterTts.setLanguage("en-US");
    
    // Try to find a male voice
    try {
      List<dynamic> voices = await _flutterTts.getVoices;
      for (var voice in voices) {
        if (voice is Map) {
          String name = (voice["name"] ?? "").toString().toLowerCase();
          if (name.contains("male") || name.contains("en-us-x-iom-local") || name.contains("guy")) {
            await _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
            break;
          }
        }
      }
    } catch (e) {
      debugPrint("Error setting male voice: $e");
    }

    await _flutterTts.setSpeechRate(0.35); // Slow, professional advisory pace
    await _flutterTts.setPitch(0.85); // Lower pitch for a natural male voice
    await _flutterTts.setVolume(1.0);
  }


  @override
  void dispose() {
    _controller.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  void _togglePlay() async {
    if (_isPlaying) {
      // Stop
      await _flutterTts.stop();
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _currentStepIndex = -1;
          _controller.stop();
        });
      }
    } else {
      // Start
      setState(() {
        _isPlaying = true;
        _currentStepIndex = 0;
        _controller.repeat(reverse: true);
      });
      _playSequence();
    }
  }

  void _playSequence() async {
    // 1. Speak Greeting - Generic
    await _flutterTts.speak("Listen carefully to the following steps.");
    
    // 2. Speak Steps
    for (int i = 0; i < widget.steps.length; i++) {
      if (!_isPlaying) break;
      if (!mounted) break;

      setState(() => _currentStepIndex = i);
      
      // Get text to speak
      String text = L10n.getLocalized(widget.lang, widget.steps[i]);
      await _flutterTts.speak(text);
      
      // Professional pause for user to process advice
      if (_isPlaying) {
        await Future.delayed(const Duration(milliseconds: 1200));
      }
    }

    // 3. Finish
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
                  _isPlaying && _currentStepIndex >= 0 && _currentStepIndex < widget.steps.length
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
