
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/colors.dart';
import '../../widgets/glass_card.dart';
import 'signup_screen.dart';
import 'otp_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: Stack(
        children: [
          // Background Elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 100,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   const Spacer(),
                   
                   // Logo & Title
                   Center(
                     child: Container(
                       padding: const EdgeInsets.all(16),
                       decoration: BoxDecoration(
                         color: Colors.white.withOpacity(0.1),
                         shape: BoxShape.circle,
                         border: Border.all(color: Colors.white.withOpacity(0.2)),
                       ),
                       child: const Icon(LucideIcons.fingerprint, size: 48, color: AppColors.primary),
                     ),
                   ),
                   const SizedBox(height: 24),
                   const Text(
                     'Welcome Back',
                     textAlign: TextAlign.center,
                     style: TextStyle(
                       fontSize: 32,
                       fontWeight: FontWeight.w900,
                       color: AppColors.textMain,
                       letterSpacing: -1,
                     ),
                   ),
                   const SizedBox(height: 8),
                   const Text(
                     'Enter your phone number to continue',
                     textAlign: TextAlign.center,
                     style: TextStyle(color: AppColors.textDim, fontSize: 16),
                   ),
                   
                   const SizedBox(height: 48),
                   
                   // Input
                   GlassCard(
                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                     child: TextFormField(
                       controller: _phoneController,
                       keyboardType: TextInputType.phone,
                       style: const TextStyle(color: AppColors.textMain, fontSize: 18, fontWeight: FontWeight.bold),
                       decoration: const InputDecoration(
                         border: InputBorder.none,
                         icon: Icon(LucideIcons.phone, color: AppColors.textDim),
                         hintText: '0911000000',
                         hintStyle: TextStyle(color: Colors.white24),
                         labelText: 'Phone Number',
                         labelStyle: TextStyle(color: AppColors.textDim),
                       ),
                     ),
                   ),
                   
                   const SizedBox(height: 24),
                   
                   // Action Button
                   ElevatedButton(
                     onPressed: () {
                       if (_phoneController.text.isNotEmpty) {
                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => OtpVerificationScreen(phoneNumber: _phoneController.text)),
                         );
                       }
                     },
                     style: ElevatedButton.styleFrom(
                       backgroundColor: AppColors.primary,
                       foregroundColor: Colors.white,
                       padding: const EdgeInsets.symmetric(vertical: 18),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                       elevation: 8,
                       shadowColor: AppColors.primary.withOpacity(0.5),
                     ),
                     child: const Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                         SizedBox(width: 8),
                         Icon(LucideIcons.arrowRight, size: 20),
                       ],
                     ),
                   ),
                   
                   const Spacer(),
                   
                   // Sign Up Link
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       const Text("Don't have an account? ", style: TextStyle(color: AppColors.textDim)),
                       TextButton(
                         onPressed: () {
                           Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                         },
                         child: const Text('Create Account', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                       ),
                     ],
                   ),
                   const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
