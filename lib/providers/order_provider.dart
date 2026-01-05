import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order_model.dart';

final ordersProvider = StateNotifierProvider<OrdersNotifier, List<ServiceOrder>>((ref) {
  return OrdersNotifier();
});

class OrdersNotifier extends StateNotifier<List<ServiceOrder>> {
  OrdersNotifier() : super([]);

  void addOrder(ServiceOrder order) {
    state = [order, ...state];
  }

  void updateStatus(String orderId, OrderStatus status) {
    state = [
      for (final order in state)
        if (order.id == orderId)
          ServiceOrder(
            id: order.id,
            serviceName: order.serviceName,
            serviceCategory: order.serviceCategory,
            customerPhone: order.customerPhone,
            orderDate: order.orderDate,
            status: status,
            amountPaid: order.amountPaid,
          )
        else
          order
    ];
  }
}
