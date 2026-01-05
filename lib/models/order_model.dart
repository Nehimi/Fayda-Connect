enum OrderStatus {
  pending,
  processing,
  completed,
  actionRequired,
}

class ServiceOrder {
  final String id;
  final String serviceName;
  final String serviceCategory;
  final String customerPhone;
  final DateTime orderDate;
  final OrderStatus status;
  final double amountPaid;

  ServiceOrder({
    required this.id,
    required this.serviceName,
    required this.serviceCategory,
    required this.customerPhone,
    required this.orderDate,
    this.status = OrderStatus.pending,
    required this.amountPaid,
  });

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending:
        return 'Waiting for Agent';
      case OrderStatus.processing:
        return 'Processing...';
      case OrderStatus.completed:
        return 'Successfully Linked';
      case OrderStatus.actionRequired:
        return 'Action Needed';
    }
  }
}
