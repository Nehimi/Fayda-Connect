import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'home_screen.dart';
import '../providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/custom_snackbar.dart';
import '../providers/auth_ui_provider.dart';
import '../utils/responsive.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      title: 'Digital ID Revolution',
      description: 'Your Fayda ID is now digital. Access government, banking, and business services securely.',
      icon: LucideIcons.fingerprint,
    ),
    OnboardingContent(
      title: 'Identity Guidance',
      description: 'Expert support for your applications. Our team provides professional guidance for all identification processes.',
      icon: LucideIcons.shieldCheck,
    ),
    OnboardingContent(
      title: 'Secure & Private',
      description: 'Your data is encrypted safely in your device vault. We prioritize your privacy.',
      icon: LucideIcons.shieldCheck,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: Stack(
        children: [
          // Background Gradient Blobs
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 100,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _contents.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: r.getSpacing(28),
                          vertical: r.getSpacing(24),
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(r.getSpacing(28)),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                                ),
                                child: Icon(
                                  _contents[index].icon,
                                  size: r.getIconSize(72),
                                  color: _currentPage == 1 ? Colors.amber : AppColors.primary,
                                ),
                              ),
                              SizedBox(height: r.getSpacing(32)),
                              Text(
                                _contents[index].title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: r.getFontSize(28),
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textMain,
                                  letterSpacing: -1,
                                ),
                              ),
                              SizedBox(height: r.getSpacing(12)),
                              Text(
                                _contents[index].description,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: r.getFontSize(15),
                                  color: AppColors.textDim,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Indicators & Button
                Padding(
                  padding: EdgeInsets.all(r.getSpacing(24)),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _contents.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(horizontal: r.getSpacing(4)),
                              height: r.getSpacing(8),
                              width: _currentPage == index ? r.getSpacing(20) : r.getSpacing(8),
                              decoration: BoxDecoration(
                                color: _currentPage == index ? AppColors.primary : Colors.white24,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: r.getSpacing(24)),
                        ElevatedButton(
                          onPressed: () {
                            if (_currentPage == _contents.length - 1) {
                              // Update state to show login screen
                              ref.read(showLoginProvider.notifier).state = true;
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, r.buttonHeight),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 8,
                            shadowColor: AppColors.primary.withValues(alpha: 0.5),
                          ),
                          child: Text(
                            _currentPage == _contents.length - 1 ? 'Get Started' : 'Next',
                            style: TextStyle(fontSize: r.getFontSize(18), fontWeight: FontWeight.bold),
                          ),
                        ),
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

class OnboardingContent {
  final String title;
  final String description;
  final IconData icon;

  OnboardingContent({required this.title, required this.description, required this.icon});
}
