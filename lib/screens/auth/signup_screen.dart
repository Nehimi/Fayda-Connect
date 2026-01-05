import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/colors.dart';
import '../../widgets/glass_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_service.dart';
import '../../services/sync_service.dart';
import '../../widgets/custom_snackbar.dart';

import 'otp_verification_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleEmailSignUp() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      CustomSnackBar.show(context, message: 'Please fill in all fields', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Create the account (AuthService will auto-send the verification link)
      final credential = await ref.read(authServiceProvider).signUpWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
      );
      
      final user = credential.user;
      if (user != null) {
        // 2. Create Firestore profile IMMEDIATELY (pending verification)
        await ref.read(syncServiceProvider).createUserProfile(
          user.uid, 
          _nameController.text, 
          _emailController.text
        );
      }
      
      if (mounted) {
        setState(() => _isLoading = false);
        // 3. Navigation is now handled naturally by AuthGate in main.dart
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        CustomSnackBar.show(context, message: 'Sign Up failed: $e', isError: true);
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
                  'Join Fayda Connect and secure your digital experience.',
                  style: TextStyle(color: AppColors.textDim, fontSize: 16),
                ),
                
                const SizedBox(height: 40),
                
                // --- FULL NAME FIELD ---
                GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: AppColors.textMain, fontSize: 16),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(LucideIcons.user, color: AppColors.textDim),
                      labelText: 'Full Name',
                      hintText: 'Abebe Kassa',
                      labelStyle: TextStyle(color: AppColors.textDim),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),

                // --- EMAIL FIELD ---
                GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: AppColors.textMain, fontSize: 16),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(LucideIcons.mail, color: AppColors.textDim),
                      labelText: 'Email Address',
                      hintText: 'abebe@example.com',
                      labelStyle: TextStyle(color: AppColors.textDim),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),

                // --- PASSWORD FIELD ---
                GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: AppColors.textMain, fontSize: 16),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(LucideIcons.lock, color: AppColors.textDim),
                      labelText: 'Password',
                      hintText: '••••••••',
                      labelStyle: TextStyle(color: AppColors.textDim),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleEmailSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 8,
                    shadowColor: AppColors.primary.withOpacity(0.5),
                  ),
                  child: _isLoading 
                   ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                   : const Text('Create Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                
                const SizedBox(height: 48),
                const Center(
                  child: Opacity(
                    opacity: 0.5,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.shieldCheck, size: 14, color: AppColors.textDim),
                        SizedBox(width: 8),
                        Text('Secured with Industry Standard Encryption', style: TextStyle(color: AppColors.textDim, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
