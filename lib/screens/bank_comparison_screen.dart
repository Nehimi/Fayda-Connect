import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../providers/language_provider.dart';
import '../providers/bank_provider.dart';
import '../models/bank_model.dart';
import 'bank_detail_screen.dart';

class BankComparisonScreen extends ConsumerWidget {
  const BankComparisonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banks = ref.watch(bankListProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text('Bank Comparison'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Partner Bank Benefits',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textMain),
          ),
          const SizedBox(height: 8),
          const Text(
            'Compare special offers and interest rates available for Fayda ID users.',
            style: TextStyle(color: AppColors.textDim),
          ),
          const SizedBox(height: 32),
          ...banks.map((bank) {
            // Find specific benefits based on bank ID
            String rate = '7.0%';
            String benefit = 'Free linking';
            
            if (bank.id == 'cbe') {
              rate = '7.5%';
              benefit = '0 ETB Fee for linking';
            } else if (bank.id == 'boa') {
              rate = '7.2%';
              benefit = 'Free Visa Card on linking';
            } else if (bank.id == 'dashen') {
              rate = '7.0%';
              benefit = '50 ETB Amole Bonus';
            }

            return _buildBankBenefitCard(context, bank, rate, benefit);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildBankBenefitCard(BuildContext context, BankService bank, String rate, String benefit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BankDetailScreen(bank: bank)),
          );
        },
        borderRadius: BorderRadius.circular(24),
        child: GlassCard(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Hero(
                    tag: 'comp_${bank.id}',
                    child: Image.network(
                      bank.logo,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 50,
                        height: 50,
                        color: AppColors.primary.withValues(alpha: 0.1),
                        child: const Icon(LucideIcons.landmark, color: AppColors.primary, size: 24),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bank.name, style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                          child: Text(rate, style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            benefit,
                            style: const TextStyle(color: AppColors.textDim, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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
}
