import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/app_drawer.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/order_provider.dart';
import '../models/order_model.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final orders = ref.watch(ordersProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text(L10n.get(lang, 'history')),
        backgroundColor: Colors.transparent,
      ),
      body: orders.isEmpty 
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.history, size: 64, color: AppColors.textDim.withValues(alpha: 0.3)),
                const SizedBox(height: 16),
                Text(
                  lang == AppLanguage.english ? 'No history yet' : 'ምንም ታሪክ የለም',
                  style: const TextStyle(color: AppColors.textDim),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final date = order.orderDate;
              final statusLabel = order.statusLabel;
              
              Color statusColor;
              switch (order.status) {
                case OrderStatus.pending: statusColor = Colors.orangeAccent; break;
                case OrderStatus.processing: statusColor = Colors.blueAccent; break;
                case OrderStatus.completed: statusColor = Colors.greenAccent; break;
                case OrderStatus.actionRequired: statusColor = Colors.redAccent; break;
              }
              
              return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GlassCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(LucideIcons.fileText, color: statusColor, size: 24),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.serviceName,
                          style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('MMM dd, yyyy').format(date),
                          style: const TextStyle(color: AppColors.textDim, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(LucideIcons.trash2, color: AppColors.textDim.withValues(alpha: 0.5), size: 18),
                    onPressed: () {
                      ref.read(ordersProvider.notifier).removeOrder(order.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(lang == AppLanguage.english ? 'Order removed' : 'ትዕዛዝ ተሰርዟል'),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          width: 200,
                        )
                      );
                    },
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
