import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../providers/cms_provider.dart';
import '../models/service_model.dart';
import 'partner_offer_screen.dart';

class BankComparisonScreen extends ConsumerWidget {
  const BankComparisonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final benefitsAsync = ref.watch(benefitsProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text('Partner Benefits'), // Updated Title
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textMain),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: benefitsAsync.when(
        data: (benefits) {
          if (benefits.isEmpty) {
            return const Center(
              child: Text(
                'No active partner offers right now.',
                style: TextStyle(color: AppColors.textDim),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text(
                'Exclusive Offers',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textMain),
              ),
              const SizedBox(height: 8),
              const Text(
                'Explore special deals and privileges available for Fayda ID users.',
                style: TextStyle(color: AppColors.textDim),
              ),
              const SizedBox(height: 32),
              ...benefits.map((benefit) {
                return _buildBenefitCard(context, benefit);
              }),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
      ),
    );
  }

  Widget _buildBenefitCard(BuildContext context, PartnerBenefit benefit) {
    final color = Color(benefit.colorHex);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PartnerOfferScreen(benefit: benefit)),
          );
        },
        borderRadius: BorderRadius.circular(24),
        child: GlassCard(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withValues(alpha: 0.2)),
                ),
                child: Icon(_getIconFromName(benefit.iconName), color: color, size: 24),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      benefit.title, 
                      style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      benefit.description,
                      style: const TextStyle(color: AppColors.textDim, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, color: AppColors.textDim, size: 20),
            ],
          ),
        ),
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
