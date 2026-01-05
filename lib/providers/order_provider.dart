import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order_model.dart';

import 'user_provider.dart';
import '../models/service_model.dart'; // Just in case, though order_model is redundant with service_model often. Let's stick to existing.

final ordersProvider = StateNotifierProvider<OrdersNotifier, List<ServiceOrder>>((ref) {
  return OrdersNotifier(ref);
});

class OrdersNotifier extends StateNotifier<List<ServiceOrder>> {
  final Ref ref;
  OrdersNotifier(this.ref) : super([]);

  void addOrder(ServiceOrder order) {
    state = [order, ...state];
  }

  void updateStatus(String orderId, OrderStatus status) {
    state = [
      for (final order in state)
        if (order.id == orderId)
          order.copyWith(status: status)
        else
          order
    ];

    // Check for "Premium" upgrade
    if (status == OrderStatus.completed) {
      final updatedOrder = state.firstWhere((order) => order.id == orderId);
      if (updatedOrder.serviceName.contains('Premium')) {
        ref.read(userProvider.notifier).setPremium(true);
      }
    }
  }

  void removeOrder(String orderId) {
    state = state.where((order) => order.id != orderId).toList();
  }
}
