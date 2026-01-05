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
import '../../services/sync_service.dart';

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
      
      if (widget.isSignUp && widget.name != null) {
        // Sync to Firestore once verified
        await ref.read(syncServiceProvider).createUserProfile(
          user.uid, 
          widget.name!, 
          widget.email!
        );
      }

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
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textMain),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               const SizedBox(height: 20),
               Container(
                 padding: const EdgeInsets.all(24),
                 decoration: BoxDecoration(
                   color: AppColors.primary.withOpacity(0.1),
                   shape: BoxShape.circle,
                 ),
                 child: const Icon(LucideIcons.mail, size: 64, color: AppColors.primary),
               ),
               const SizedBox(height: 32),
               const Text(
                 'Verify Your Email',
                 style: TextStyle(
                   fontSize: 28,
                   fontWeight: FontWeight.w900,
                   color: AppColors.textMain,
                   letterSpacing: -1,
                 ),
               ),
               const SizedBox(height: 16),
               RichText(
                 textAlign: TextAlign.center,
                 text: TextSpan(
                   style: const TextStyle(color: AppColors.textDim, fontSize: 16, height: 1.5),
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
               
               const SizedBox(height: 48),

               GlassCard(
                 padding: const EdgeInsets.all(20),
                 child: Row(
                   children: [
                     const SizedBox(
                       width: 20,
                       height: 20,
                       child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                     ),
                     const SizedBox(width: 16),
                     const Expanded(
                       child: Text(
                         'Waiting for verification...',
                         style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.w600),
                       ),
                     ),
                   ],
                 ),
               ),
               
               const SizedBox(height: 32),
               
               ElevatedButton(
                 onPressed: _checkVerificationStatus,
                 style: ElevatedButton.styleFrom(
                   backgroundColor: AppColors.primary,
                   foregroundColor: Colors.white,
                   minimumSize: const Size(double.infinity, 56),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                   elevation: 8,
                   shadowColor: AppColors.primary.withOpacity(0.5),
                 ),
                 child: const Text('I Have Verified', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
               ),
               
               const Spacer(),
               
               Text(
                 "Didn't receive the email?",
                 style: TextStyle(color: AppColors.textDim.withOpacity(0.7)),
               ),
               TextButton(
                 onPressed: _handleResendEmail,
                 child: const Text("Resend Verification Link", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
               ),
               const SizedBox(height: 8),
               TextButton(
                 onPressed: () => ref.read(authServiceProvider).signOut(),
                 child: Text("Cancel & Sign Out", style: TextStyle(color: Colors.redAccent.withOpacity(0.8))),
               ),
               const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
