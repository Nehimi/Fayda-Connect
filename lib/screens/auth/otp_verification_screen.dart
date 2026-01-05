
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/colors.dart';
import '../../widgets/glass_card.dart';
import '../home_screen.dart';
import '../../widgets/custom_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final bool isSignUp;
  final String? name;

  const OtpVerificationScreen({super.key, required this.phoneNumber, this.isSignUp = false, this.name});

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() {
    String otp = _controllers.map((c) => c.text).join();
    if (otp.length == 4) {
      // Simulate verification
      if (widget.isSignUp && widget.name != null) {
          // Update user name in provider if signing up (mock)
          // Ideally we'd call an API here
      }
      
      CustomSnackBar.show(context, message: 'Verification Successful!');
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } else {
       CustomSnackBar.show(context, message: 'Please enter a valid 4-digit code', isError: true);
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
               const Icon(LucideIcons.messageSquare, size: 48, color: AppColors.primary),
               const SizedBox(height: 24),
               const Text(
                 'Verification Code',
                 style: TextStyle(
                   fontSize: 28,
                   fontWeight: FontWeight.w900,
                   color: AppColors.textMain,
                   letterSpacing: -1,
                 ),
               ),
               const SizedBox(height: 8),
               Text(
                 'We sent a 4-digit code to ${widget.phoneNumber}',
                 textAlign: TextAlign.center,
                 style: const TextStyle(color: AppColors.textDim, fontSize: 16),
               ),
               
               const SizedBox(height: 48),
               
               // OTP Input
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: List.generate(4, (index) {
                   return SizedBox(
                     width: 60,
                     height: 70,
                     child: GlassCard(
                        padding: EdgeInsets.zero,
                        borderRadius: 12,
                        child: Center(
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textMain),
                            maxLength: 1,
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 3) {
                                _focusNodes[index + 1].requestFocus();
                              } else if (value.isEmpty && index > 0) {
                                _focusNodes[index - 1].requestFocus();
                              }
                              
                              if (index == 3 && value.isNotEmpty) {
                                _verifyOtp();
                              }
                            },
                          ),
                        ),
                     ),
                   );
                 }),
               ),
               
               const SizedBox(height: 40),
               
               ElevatedButton(
                 onPressed: _verifyOtp,
                 style: ElevatedButton.styleFrom(
                   backgroundColor: AppColors.primary,
                   foregroundColor: Colors.white,
                   minimumSize: const Size(double.infinity, 56),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                   elevation: 8,
                   shadowColor: AppColors.primary.withOpacity(0.5),
                 ),
                 child: const Text('Verify', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
               ),
               
               const Spacer(),
               
               TextButton(
                 onPressed: () {
                    CustomSnackBar.show(context, message: 'New code sent!');
                 },
                 child: const Text("Didn't receive code? Resend", style: TextStyle(color: AppColors.textDim)),
               ),
               const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
