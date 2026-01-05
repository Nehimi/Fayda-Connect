
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/colors.dart';
import '../../widgets/glass_card.dart';
import 'otp_verification_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               const Text(
                 'Create Account',
                 style: TextStyle(
                   fontSize: 32,
                   fontWeight: FontWeight.w900,
                   color: AppColors.textMain,
                   letterSpacing: -1,
                 ),
               ),
               const SizedBox(height: 8),
               const Text(
                 'Join Fayda Connect to access premium services.',
                 style: TextStyle(color: AppColors.textDim, fontSize: 16),
               ),
               
               const SizedBox(height: 48),
               
               // Name Input
               GlassCard(
                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                 child: TextFormField(
                   controller: _nameController,
                   style: const TextStyle(color: AppColors.textMain, fontSize: 18, fontWeight: FontWeight.bold),
                   decoration: const InputDecoration(
                     border: InputBorder.none,
                     icon: Icon(LucideIcons.user, color: AppColors.textDim),
                     labelText: 'Full Name',
                     labelStyle: TextStyle(color: AppColors.textDim),
                   ),
                 ),
               ),

               const SizedBox(height: 16),

               // Phone Input
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
               
               const SizedBox(height: 32),
               
               // Action Button
               ElevatedButton(
                 onPressed: () {
                   if (_phoneController.text.isNotEmpty && _nameController.text.isNotEmpty) {
                      Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => OtpVerificationScreen(phoneNumber: _phoneController.text, isSignUp: true, name: _nameController.text)),
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
                 child: const Text('Sign Up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
               ),
            ],
          ),
        ),
      ),
    );
  }
}
