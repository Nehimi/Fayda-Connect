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
    final r = context.responsive;
    final maxContentWidth = 520.0;
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: Stack(
        children: [
          // Background Glow
          Positioned(top: -80, right: -80, child: _CircularGlow(color: AppColors.primary, size: r.isSmallPhone ? 200 : 260)),
          Positioned(bottom: -80, left: -80, child: _CircularGlow(color: AppColors.secondary, size: r.isSmallPhone ? 200 : 260)),
          
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
                      horizontal: r.horizontalPadding
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxContentWidth),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                             SizedBox(height: r.getSpacing(20)),
                             _LogoHeader(),
                             SizedBox(height: r.getSpacing(36)),
                             
                             // --- EMAIL FIELD ---
                             GlassCard(
                               padding: EdgeInsets.symmetric(horizontal: 16, vertical: r.getSpacing(4)),
                               child: TextFormField(
                                 controller: _emailController,
                                 keyboardType: TextInputType.emailAddress,
                                 style: TextStyle(color: AppColors.textMain, fontSize: r.getFontSize(16)),
                                 decoration: InputDecoration(
                                   border: InputBorder.none,
                                   icon: const Icon(LucideIcons.mail, color: AppColors.textDim),
                                   hintText: 'user@example.com',
                                   labelText: 'Email Address',
                                   labelStyle: const TextStyle(color: AppColors.textDim),
                                 ),
                               ),
                             ),
                             
                             SizedBox(height: r.getSpacing(12)),

                             // --- PASSWORD FIELD ---
                             GlassCard(
                               padding: EdgeInsets.symmetric(horizontal: 16, vertical: r.getSpacing(4)),
                               child: TextFormField(
                                 controller: _passwordController,
                                 obscureText: true,
                                 style: TextStyle(color: AppColors.textMain, fontSize: r.getFontSize(16)),
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
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(color: AppColors.textDim, fontSize: r.getFontSize(13)),
                                ),
                              ),
                            ),
                            
                            SizedBox(height: r.getSpacing(12)),
                            
                            ElevatedButton(
                               onPressed: _isLoading ? null : _handleEmailLogin,
                               style: ElevatedButton.styleFrom(
                                 backgroundColor: AppColors.primary,
                                 foregroundColor: Colors.white,
                                 padding: EdgeInsets.symmetric(vertical: r.getSpacing(16)),
                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                 elevation: 8,
                                 shadowColor: AppColors.primary.withValues(alpha: 0.5),
                               ),
                               child: Text(_isLoading ? 'Authenticating...' : 'Sign In', style: TextStyle(fontSize: r.getFontSize(18), fontWeight: FontWeight.bold)),
                             ),
                             
                             SizedBox(height: r.getSpacing(32)),
                             
                             // Sign Up Link
                              Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Text("New user? ", style: TextStyle(color: AppColors.textDim, fontSize: r.getFontSize(13))),
                                 TextButton(
                                   onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen())),
                                   child: Text('Create Official Account', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: r.getFontSize(14))),
                                 ),
                               ],
                             ),
                             SizedBox(height: r.getSpacing(24)),
                              
                              // Government Disclaimer
                              Container(
                                padding: EdgeInsets.all(r.getSpacing(12)),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(LucideIcons.alertTriangle, size: 16, color: Colors.orange),
                                        SizedBox(width: r.getSpacing(8)),
                                        Text('NOT A GOVERNMENT APP', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: r.getFontSize(12))),
                                      ],
                                    ),
                                    SizedBox(height: r.getSpacing(4)),
                                    Text(
                                      'Fayda-Connect is an independent utility tool. We are NOT affiliated with the Ethiopian Government or NIDP. Your data is stored locally.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: AppColors.textDim, fontSize: r.getFontSize(11)),
                                    ),
                                  ],
                                ),
                              ),
                             SizedBox(height: r.getSpacing(32)),
                          ],
                        ),
                      ),
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
  final double size;
  const _CircularGlow({required this.color, this.size = 300});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
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
