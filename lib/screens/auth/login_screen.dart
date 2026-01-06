import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/colors.dart';
import '../../widgets/glass_card.dart';
import 'signup_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_snackbar.dart';
import '../../providers/auth_ui_provider.dart';
import '../../utils/responsive.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleForgotPassword() async {
    if (_emailController.text.isEmpty) {
      CustomSnackBar.show(context, message: 'Please enter your email first', isError: true);
      return;
    }

    try {
      await ref.read(authServiceProvider).sendPasswordResetEmail(_emailController.text);
      if (mounted) {
        CustomSnackBar.show(context, message: 'Password reset link sent to your email!');
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.show(context, message: 'Error: $e', isError: true);
      }
    }
  }

  void _handleEmailLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      CustomSnackBar.show(context, message: 'Please enter both email and password', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(authServiceProvider).signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        CustomSnackBar.show(context, message: 'Login failed: $e', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: Stack(
        children: [
          // Background Glow
          Positioned(top: -100, right: -100, child: _CircularGlow(color: AppColors.primary)),
          Positioned(bottom: -100, left: -100, child: _CircularGlow(color: AppColors.secondary)),
          
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.textMain),
                    onPressed: () => ref.read(showLoginProvider.notifier).state = false,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.responsive.horizontalPadding
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                         SizedBox(height: context.responsive.getSpacing(20)),
                         _LogoHeader(),
                         SizedBox(height: context.responsive.getSpacing(48)),
                         
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
                               hintText: 'user@example.com',
                               labelText: 'Email Address',
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
                               hintText: '••••••••',
                               labelText: 'Password',
                               labelStyle: TextStyle(color: AppColors.textDim),
                             ),
                           ),
                        ),
                        
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _handleForgotPassword,
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: AppColors.textDim, fontSize: 13),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        ElevatedButton(
                           onPressed: _isLoading ? null : _handleEmailLogin,
                           style: ElevatedButton.styleFrom(
                             backgroundColor: AppColors.primary,
                             foregroundColor: Colors.white,
                             padding: const EdgeInsets.symmetric(vertical: 18),
                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                             elevation: 8,
                             shadowColor: AppColors.primary.withValues(alpha: 0.5),
                           ),
                           child: Text(_isLoading ? 'Authenticating...' : 'Sign In', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                         ),
                         
                         const SizedBox(height: 40),
                         
                         // Sign Up Link
                          Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             const Text("New user? ", style: TextStyle(color: AppColors.textDim)),
                             TextButton(
                               onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen())),
                               child: const Text('Create Official Account', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                             ),
                           ],
                         ),
                         const SizedBox(height: 32),
                          
                          // Government Disclaimer
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orange.withOpacity(0.3)),
                            ),
                            child: const Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(LucideIcons.alertTriangle, size: 16, color: Colors.orange),
                                    SizedBox(width: 8),
                                    Text('NOT A GOVERNMENT APP', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Fayda-Connect is an independent utility tool. We are NOT affiliated with the Ethiopian Government or NIDP. Your data is stored locally.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppColors.textDim, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                         const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircularGlow extends StatelessWidget {
  final Color color;
  const _CircularGlow({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, height: 300,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 100, spreadRadius: 20)],
      ),
    );
  }
}

class _LogoHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), shape: BoxShape.circle, border: Border.all(color: Colors.white12)),
          child: const Icon(LucideIcons.fingerprint, size: 56, color: AppColors.primary),
        ),
        const SizedBox(height: 24),
        const Text('Fayda Connect', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.textMain, letterSpacing: -1)),
        const Text('Secure Identity Gateway', style: TextStyle(color: AppColors.textDim, fontSize: 16)),
      ],
    );
  }
}
