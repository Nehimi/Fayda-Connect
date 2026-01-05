import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';
import '../widgets/custom_snackbar.dart';

import 'scanner_result_screen.dart';
import 'dart:async';

enum ScannerMode { ocr, photoValidation }

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  ScannerMode _mode = ScannerMode.ocr;
  bool _isProcessing = false;
  double _validationProgress = 0.0;
  String _validationStatus = 'Scanning...';

  void _startProcess() {
    setState(() {
      _isProcessing = true;
      _validationProgress = 0.0;
    });

    if (_mode == ScannerMode.ocr) {
      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ScannerResultScreen(
                scannedData: {
                  'Full Name': 'Abenezer Kebede',
                  'Fayda ID': 'FIN-1234-5678',
                  'Date of Birth': '12 Oct 1990',
                  'Nationality': 'Ethiopian',
                  'Expiry Date': '01 Jan 2030',
                },
              ),
            ),
          );
        }
      });
    } else {
      // AI Photo Validation Simulation
      _simulatePhotoValidation();
    }
  }

  void _simulatePhotoValidation() async {
    final stages = [
      'Face Detection...',
      'Lighting Check...',
      'Background Analysis...',
      'Resolution Check...',
      'VERIFIED'
    ];

    for (int i = 0; i < stages.length; i++) {
      if (!mounted) return;
      setState(() {
        _validationStatus = stages[i];
        _validationProgress = (i + 1) / stages.length;
      });
      await Future.delayed(const Duration(seconds: 1));
    }

    if (mounted) {
      CustomSnackBar.show(context, message: 'Photo Meets Official Standards!', color: AppColors.success);
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text(_mode == ScannerMode.ocr ? L10n.get(lang, 'scan_id') : L10n.get(lang, 'photo_validator')),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          _buildModeSwitcher(lang),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              _mode == ScannerMode.ocr ? L10n.get(lang, 'ready_scan') : L10n.get(lang, 'photo_validator'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textMain, fontSize: 24, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              _mode == ScannerMode.ocr 
                ? 'Point your camera at the Fayda QR code or FIN card.' 
                : L10n.get(lang, 'photo_valid_desc'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textDim, fontSize: 13),
            ),
          ),
          const Spacer(),
          _buildScannerFrame(),
          const Spacer(),
          if (!_isProcessing)
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 64),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: _startProcess,
                child: Text('START ${_mode == ScannerMode.ocr ? 'SCAN' : 'VALIDATION'}', style: const TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
          if (_isProcessing && _mode == ScannerMode.photoValidation)
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  Text(_validationStatus, style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: _validationProgress, color: AppColors.success, backgroundColor: AppColors.success.withValues(alpha: 0.1)),
                ],
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildModeSwitcher(AppLanguage lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GlassCard(
        padding: const EdgeInsets.all(4),
        borderRadius: 20,
        child: Row(
          children: [
            Expanded(
              child: _ModeButton(
                label: L10n.get(lang, 'scan_id'),
                isActive: _mode == ScannerMode.ocr,
                onTap: () => setState(() => _mode = ScannerMode.ocr),
              ),
            ),
            Expanded(
              child: _ModeButton(
                label: 'AI PHOTO',
                isActive: _mode == ScannerMode.photoValidation,
                onTap: () => setState(() => _mode = ScannerMode.photoValidation),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerFrame() {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: _mode == ScannerMode.ocr ? AppColors.primary : AppColors.success, width: 2),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              _mode == ScannerMode.ocr ? LucideIcons.scan : LucideIcons.user,
              size: 100,
              color: (_mode == ScannerMode.ocr ? AppColors.primary : AppColors.success).withValues(alpha: 0.2),
            ),
          ),
          _buildCorner(Alignment.topLeft),
          _buildCorner(Alignment.topRight),
          _buildCorner(Alignment.bottomLeft),
          _buildCorner(Alignment.bottomRight),
          if (_isProcessing) const _ScanningLine(),
        ],
      ),
    );
  }

  Widget _buildCorner(Alignment alignment) {
    final color = _mode == ScannerMode.ocr ? AppColors.primary : AppColors.success;
    return Align(
      alignment: alignment,
      child: Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            top: (alignment == Alignment.topLeft || alignment == Alignment.topRight) ? BorderSide(color: color, width: 4) : BorderSide.none,
            bottom: (alignment == Alignment.bottomLeft || alignment == Alignment.bottomRight) ? BorderSide(color: color, width: 4) : BorderSide.none,
            left: (alignment == Alignment.topLeft || alignment == Alignment.bottomLeft) ? BorderSide(color: color, width: 4) : BorderSide.none,
            right: (alignment == Alignment.topRight || alignment == Alignment.bottomRight) ? BorderSide(color: color, width: 4) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ModeButton({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: isActive ? Colors.white : AppColors.textDim, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ),
    );
  }
}

class _ScanningLine extends StatefulWidget {
  const _ScanningLine();

  @override
  State<_ScanningLine> createState() => _ScanningLineState();
}

class _ScanningLineState extends State<_ScanningLine> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          top: 280 * _controller.value,
          left: 0,
          right: 0,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.5), blurRadius: 10, spreadRadius: 2)],
              color: AppColors.primary,
            ),
          ),
        );
      },
    );
  }
}
