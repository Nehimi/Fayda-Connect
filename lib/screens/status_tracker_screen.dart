import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';
import '../widgets/custom_snackbar.dart';

class StatusTrackerScreen extends ConsumerStatefulWidget {
  const StatusTrackerScreen({super.key});

  @override
  ConsumerState<StatusTrackerScreen> createState() => _StatusTrackerScreenState();
}

class _StatusTrackerScreenState extends ConsumerState<StatusTrackerScreen> {
  final TextEditingController _idController = TextEditingController();
  bool _isSearching = false;
  Map<String, dynamic>? _statusResult;

  void _searchStatus() async {
    if (_idController.text.isEmpty) {
      CustomSnackBar.show(context, message: 'Please enter an ID');
      return;
    }

    setState(() {
      _isSearching = true;
      _statusResult = null;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isSearching = false;
        _statusResult = {
          'id': _idController.text,
          'status': 'Processing',
          'last_update': 'Jan 05, 2026',
          'location': 'Addis Ababa Central Office',
          'estimate': 'Jan 15, 2026',
          'progress': 0.65,
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text(L10n.get(lang, 'status_tracker')),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L10n.get(lang, 'status_tracker'),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textMain, letterSpacing: -1),
            ),
            const SizedBox(height: 8),
            Text(
              L10n.get(lang, 'track_desc'),
              style: const TextStyle(color: AppColors.textDim, fontSize: 16),
            ),
            const SizedBox(height: 32),
            GlassCard(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _idController,
                      style: const TextStyle(color: AppColors.textMain),
                      decoration: InputDecoration(
                        hintText: L10n.get(lang, 'track_id'),
                        hintStyle: const TextStyle(color: AppColors.textDim),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _searchStatus,
                    icon: _isSearching 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(LucideIcons.search, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            if (_statusResult != null) _buildResultCard(lang),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(AppLanguage lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(LucideIcons.activity, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Text(
              'Application Status'.toUpperCase(),
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_statusResult!['status'], style: const TextStyle(color: AppColors.textMain, fontSize: 24, fontWeight: FontWeight.w900)),
                      const Text('Current Progress', style: TextStyle(color: AppColors.textDim, fontSize: 13)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: const Icon(LucideIcons.clock, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _statusResult!['progress'],
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  color: AppColors.primary,
                  minHeight: 10,
                ),
              ),
              const SizedBox(height: 40),
              _buildTimelineStep('Pre-Registration', 'Completed', true, isCurrent: false),
              _buildTimelineStep('Biometric Appointment', 'Completed', true, isCurrent: false),
              _buildTimelineStep('Data Validation', 'In Progress', true, isCurrent: true),
              _buildTimelineStep('ID Printing', 'Queueing', false, isCurrent: false),
              _buildTimelineStep('Ready for Collection', 'Pending', false, isCurrent: false),
              const SizedBox(height: 32),
              const Divider(color: AppColors.glassBorder, height: 1),
              const SizedBox(height: 24),
              _buildInfoRow('Reference ID', _statusResult!['id']),
              _buildInfoRow('Last Updated', _statusResult!['last_update']),
              _buildInfoRow('Location', _statusResult!['location']),
              _buildInfoRow('Estimated Delivery', _statusResult!['estimate']),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineStep(String title, String status, bool isDone, {required bool isCurrent}) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? AppColors.primary : AppColors.glassBorder,
                border: isCurrent ? Border.all(color: Colors.white, width: 2) : null,
                boxShadow: isCurrent ? [BoxShadow(color: AppColors.primary.withOpacity(0.5), blurRadius: 10)] : null,
              ),
            ),
            Container(
              width: 2,
              height: 30,
              color: isDone ? AppColors.primary : AppColors.glassBorder,
            ),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isCurrent ? AppColors.textMain : (isDone ? AppColors.textMain.withOpacity(0.8) : AppColors.textDim),
                  fontWeight: isCurrent ? FontWeight.w900 : (isDone ? FontWeight.w700 : FontWeight.w500),
                  fontSize: 14,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  color: isCurrent ? AppColors.primary : AppColors.textDim,
                  fontSize: 12,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textDim, fontSize: 13)),
          Text(value, style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
