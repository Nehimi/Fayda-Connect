import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/app_drawer.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(L10n.get(lang, 'history')),
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(LucideIcons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: 3,
        itemBuilder: (context, index) {
          final titles = [
            L10n.get(lang, 'order_item_1'),
            L10n.get(lang, 'order_item_2'),
            L10n.get(lang, 'order_item_3'),
          ];
          final dates = [DateTime.now(), DateTime.now().subtract(const Duration(days: 2)), DateTime.now().subtract(const Duration(days: 5))];
          final statuses = [
            L10n.get(lang, 'status_comp'),
            L10n.get(lang, 'status_proc'),
            L10n.get(lang, 'status_fail'),
          ];
          final colors = [Colors.greenAccent, Colors.orangeAccent, Colors.redAccent];
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GlassCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors[index].withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(LucideIcons.fileText, color: colors[index], size: 24),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titles[index],
                          style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('MMM dd, yyyy').format(dates[index]),
                          style: const TextStyle(color: AppColors.textDim, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colors[index].withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statuses[index],
                      style: TextStyle(color: colors[index], fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
