import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../theme/colors.dart';

class _StatusIndicator extends StatelessWidget {
  final OrderStatus status;
  const _StatusIndicator({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case OrderStatus.pending: color = Colors.orange; break;
      case OrderStatus.processing: color = Colors.blue; break;
      case OrderStatus.completed: color = Colors.green; break;
      case OrderStatus.actionRequired: color = Colors.red; break;
    }

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 4, spreadRadius: 1),
        ],
      ),
    );
  }
}
