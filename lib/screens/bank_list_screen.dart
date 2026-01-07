import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/bank_provider.dart';
import '../models/bank_model.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/app_drawer.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';
import 'bank_detail_screen.dart';

class BankListScreen extends ConsumerStatefulWidget {
  const BankListScreen({super.key});

  @override
  ConsumerState<BankListScreen> createState() => _BankListScreenState();
}

class _BankListScreenState extends ConsumerState<BankListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final allBanks = ref.watch(bankListProvider);
    final currentLang = ref.watch(languageProvider);

    // Filter Logic
    final filteredBanks = allBanks.where((bank) {
      final query = _searchQuery.toLowerCase();
      return bank.name.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text(L10n.get(ref.watch(languageProvider), 'banking')),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 200,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.05),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: GlassCard(
                  padding: EdgeInsets.zero,
                  borderRadius: 20,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    style: const TextStyle(color: AppColors.textMain),
                    decoration: InputDecoration(
                      hintText: currentLang == AppLanguage.english ? 'Search for a bank...' : 'ባንክ ይፈልጉ...',
                      hintStyle: const TextStyle(color: AppColors.textDim),
                      prefixIcon: const Icon(LucideIcons.search, color: AppColors.textDim, size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: filteredBanks.isEmpty 
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.landmark, size: 48, color: AppColors.textDim.withValues(alpha: 0.3)),
                          const SizedBox(height: 16),
                          Text(
                            currentLang == AppLanguage.english ? 'No banks found' : 'ምንም ባንክ አልተገኘም',
                            style: const TextStyle(color: AppColors.textDim, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredBanks.length,
                  itemBuilder: (context, index) {
                    final bank = filteredBanks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GlassCard(
                        padding: EdgeInsets.zero,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Hero(
                            tag: bank.id,
                            child: Container(
                              width: 60,
                              height: 60,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Image.network(
                                bank.logo,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(LucideIcons.landmark, color: AppColors.primary, size: 30),
                              ),
                            ),
                          ),
                          title: Text(
                            bank.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: AppColors.textMain,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: bank.type == BankType.online ? AppColors.success : AppColors.accent,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  bank.typeLabel,
                                  style: TextStyle(
                                    color: AppColors.textDim,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: const Icon(LucideIcons.chevronRight, color: AppColors.textDim, size: 20),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BankDetailScreen(bank: bank),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
