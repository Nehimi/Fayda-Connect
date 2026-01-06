import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/service_model.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../utils/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnerOfferScreen extends StatelessWidget {
  final PartnerBenefit benefit;

  const PartnerOfferScreen({super.key, required this.benefit});

  Future<void> _launchUrl(BuildContext context, String url) async {
    try {
      String sanitizedUrl = url.trim();
      if (!sanitizedUrl.startsWith('http')) {
        sanitizedUrl = 'https://$sanitizedUrl';
      }
      final uri = Uri.parse(sanitizedUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open link')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid link format')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(benefit.colorHex);
    
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: Stack(
        children: [
          // Decorative background blobs
          Positioned(
            top: -100,
            right: -100,
            child: _BlurBlob(color: color.withValues(alpha: 0.2), size: 300),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: _BlurBlob(color: AppColors.primary.withValues(alpha: 0.1), size: 250),
          ),
          
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textMain),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  background: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: color.withValues(alpha: 0.2), width: 2),
                      ),
                      child: Icon(_getIconFromName(benefit.iconName), color: color, size: 64),
                    ),
                  ),
                ),
              ),
              
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'EXCLUSIVE PARTNER OFFER',
                          style: TextStyle(
                            color: color,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        benefit.title,
                        style: const TextStyle(
                          color: AppColors.textMain,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        benefit.description,
                        style: TextStyle(
                          color: AppColors.textMain.withValues(alpha: 0.7),
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      if ((benefit.features ?? []).isNotEmpty) ...[
                        const Text(
                          'Benefits Summary',
                          style: TextStyle(
                            color: AppColors.textMain,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...(benefit.features ?? []).map((feature) => _buildBenefitItem(LucideIcons.checkCircle2, feature, color)),
                      ],
                      
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Claim Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                width: double.infinity,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.8)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (benefit.deepLink != null && benefit.deepLink!.startsWith('http')) {
                        _launchUrl(context, benefit.deepLink!);
                      } else {
                        // Fallback or show a success message
                         ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: color,
                            content: const Text('Pro Benefit Activated! Redirecting...', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.sparkles, color: Colors.white, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            'CLAIM PRO BENEFIT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(color: AppColors.textMain, fontSize: 14),
          ),
        ],
      ),
    );
  }

  IconData _getIconFromName(String name) {
    switch (name) {
      case 'percent': return LucideIcons.percent;
      case 'trendingDown': return LucideIcons.trendingDown;
      case 'gift': return LucideIcons.gift;
      case 'info': return LucideIcons.info;
      case 'award': return LucideIcons.award;
      case 'megaphone': return LucideIcons.megaphone;
      case 'shield': return LucideIcons.shield;
      default: return LucideIcons.star;
    }
  }
}

class _BlurBlob extends StatelessWidget {
  final Color color;
  final double size;
  const _BlurBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}
