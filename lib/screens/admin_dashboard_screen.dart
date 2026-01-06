import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/order_provider.dart';
import '../models/order_model.dart';
import '../theme/colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/glass_card.dart';
import 'package:intl/intl.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.refreshCw),
            onPressed: () {
              // Refresh logic or state reset for testing
            },
          ),
        ],
      ),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.clipboardList, size: 64, color: AppColors.textDim.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  const Text('No orders yet', style: TextStyle(color: AppColors.textDim)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _AdminOrderCard(order: order);
              },
            ),
    );
  }
}

class _AdminOrderCard extends ConsumerWidget {
  final ServiceOrder order;
  const _AdminOrderCard({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        borderColor: _getStatusColor(order.status).withValues(alpha: 0.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.serviceName,
                      style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy • HH:mm').format(order.orderDate),
                      style: const TextStyle(color: AppColors.textDim, fontSize: 12),
                    ),
                  ],
                ),
                _StatusBadge(status: order.status),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.glassBorder),
            const SizedBox(height: 16),
            
            _buildInfoRow(LucideIcons.phone, 'Customer', order.customerPhone),
            _buildInfoRow(LucideIcons.star, 'Credits', '${order.amountPaid} pts'),
            
            if (order.formData != null && order.formData!.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Form Data:', style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: order.formData!.entries.map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e.key, style: const TextStyle(color: AppColors.textDim, fontSize: 12)),
                        Text(e.value, style: const TextStyle(color: AppColors.textMain, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )).toList(),
                ),
              ),
            ],
            
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showStatusPicker(context, ref),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Update Status', style: TextStyle(color: AppColors.primary)),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(LucideIcons.messageSquare, color: AppColors.primary, size: 20),
                    onPressed: () {
                      // Open telegram chat with customer
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.textDim),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(color: AppColors.textDim, fontSize: 14)),
          Text(value, style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }

  void _showStatusPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Update Order Status', style: TextStyle(color: AppColors.textMain, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ...OrderStatus.values.map((s) => ListTile(
              leading: Icon(LucideIcons.circle, color: _getStatusColor(s), size: 16),
              title: Text(s.name.toUpperCase(), style: const TextStyle(color: AppColors.textMain)),
              onTap: () {
                ref.read(ordersProvider.notifier).updateStatus(order.id, s);
                Navigator.pop(context);
                CustomSnackBar.show(context, message: 'Order status updated to ${s.name.toUpperCase()}');
              },
            )).toList(),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending: return Colors.orange;
      case OrderStatus.processing: return Colors.blue;
      case OrderStatus.completed: return Colors.green;
      case OrderStatus.actionRequired: return Colors.red;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    
    switch (status) {
      case OrderStatus.pending:
        color = Colors.orange;
        label = 'Pending';
        break;
      case OrderStatus.processing:
        color = Colors.blue;
        label = 'Processing';
        break;
      case OrderStatus.completed:
        color = Colors.green;
        label = 'Completed';
        break;
      case OrderStatus.actionRequired:
        color = Colors.red;
        label = 'Action Needed';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
