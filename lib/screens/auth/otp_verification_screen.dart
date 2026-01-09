import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/colors.dart';
import '../../widgets/glass_card.dart';
import '../home_screen.dart';
import '../../widgets/custom_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_service.dart';
import '../../utils/responsive.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final bool isSignUp;
  final String? name;
  final String? email;
  final String? password;

  const OtpVerificationScreen({
    super.key, 
    required this.phoneNumber, 
    required this.verificationId,
    this.isSignUp = false, 
    this.name,
    this.email,
    this.password,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}


class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  bool _isVerifying = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Auto-check status every 2 seconds for a snappier experience
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _checkVerificationStatus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _checkVerificationStatus() async {
    final authService = ref.read(authServiceProvider);
    
    // UI Feedback for manual click
    if (mounted) setState(() => _isVerifying = true);

    try {
      await authService.reloadUser();
      final user = authService.currentUser;
      
      debugPrint("Checking verification for: ${user?.email}");
      debugPrint("Status code: ${user?.emailVerified}");

      if (user != null && user.emailVerified) {
        _timer?.cancel();

        if (mounted) {
          CustomSnackBar.show(context, message: 'Email Verified Successfully!');
        }
      } else {
        if (_isVerifying && mounted) {
           CustomSnackBar.show(context, message: 'Still waiting for verification... Make sure you clicked the link.', isError: true);
        }
      }
    } catch (e) {
      debugPrint("Verification Check Error: $e");
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  void _handleResendEmail() async {
    try {
      await ref.read(authServiceProvider).sendEmailVerification();
      if (mounted) {
        CustomSnackBar.show(context, message: 'Verification link resent!');
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.show(context, message: 'Error resending: $e', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Navigator.canPop(context) 
          ? IconButton(
              icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textMain),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(r.getSpacing(20)),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   SizedBox(height: r.getSpacing(20)),
                   Container(
                     padding: EdgeInsets.all(r.getSpacing(24)),
                     decoration: BoxDecoration(
                       color: AppColors.primary.withValues(alpha: 0.1),
                       shape: BoxShape.circle,
                     ),
                     child: Icon(LucideIcons.mail, size: r.getIconSize(64), color: AppColors.primary),
                   ),
                   SizedBox(height: r.getSpacing(28)),
                   Text(
                     'Verify Your Email',
                     textAlign: TextAlign.center,
                     style: TextStyle(
                       fontSize: r.getFontSize(26),
                       fontWeight: FontWeight.w900,
                       color: AppColors.textMain,
                       letterSpacing: -1,
                     ),
                   ),
                   SizedBox(height: r.getSpacing(12)),
                   RichText(
                     textAlign: TextAlign.center,
                     text: TextSpan(
                       style: TextStyle(color: AppColors.textDim, fontSize: r.getFontSize(15), height: 1.5),
                       children: [
                         const TextSpan(text: 'We have sent a verification link to\n'),
                         TextSpan(
                           text: widget.phoneNumber,
                           style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold),
                         ),
                         const TextSpan(text: '.\nPlease check your inbox and click the link to continue.'),
                       ],
                     ),
                   ),
                   
                   SizedBox(height: r.getSpacing(32)),

                   GlassCard(
                     padding: EdgeInsets.all(r.getSpacing(16)),
                     child: Row(
                       children: [
                         SizedBox(
                           width: r.getSpacing(20),
                           height: r.getSpacing(20),
                           child: const CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                         ),
                         SizedBox(width: r.getSpacing(12)),
                         Expanded(
                           child: Text(
                             'Waiting for verification...',
                             style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.w600, fontSize: r.getFontSize(14)),
                           ),
                         ),
                       ],
                     ),
                   ),
                   
                   SizedBox(height: r.getSpacing(24)),
                   
                   ElevatedButton(
                     onPressed: _checkVerificationStatus,
                     style: ElevatedButton.styleFrom(
                       backgroundColor: AppColors.primary,
                       foregroundColor: Colors.white,
                       minimumSize: Size(double.infinity, r.buttonHeight),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                       elevation: 8,
                       shadowColor: AppColors.primary.withValues(alpha: 0.5),
                     ),
                     child: Text('I Have Verified', style: TextStyle(fontSize: r.getFontSize(17), fontWeight: FontWeight.bold)),
                   ),
                   
                   SizedBox(height: r.getSpacing(20)),
                   
                   Text(
                     "Didn't receive the email?",
                     style: TextStyle(color: AppColors.textDim.withValues(alpha: 0.7), fontSize: r.getFontSize(13)),
                   ),
                   TextButton(
                     onPressed: _handleResendEmail,
                     child: Text("Resend Verification Link", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: r.getFontSize(14))),
                   ),
                   SizedBox(height: r.getSpacing(6)),
                   TextButton(
                     onPressed: () => ref.read(authServiceProvider).signOut(),
                     child: Text("Cancel & Sign Out", style: TextStyle(color: Colors.redAccent.withValues(alpha: 0.8), fontSize: r.getFontSize(14))),
                   ),
                   SizedBox(height: r.getSpacing(12)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
