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
  final Map<String, String>? formData;

  ServiceOrder({
    required this.id,
    required this.serviceName,
    required this.serviceCategory,
    required this.customerPhone,
    required this.orderDate,
    this.status = OrderStatus.pending,
    required this.amountPaid,
    this.formData,
  });

  ServiceOrder copyWith({
    String? id,
    String? serviceName,
    String? serviceCategory,
    String? customerPhone,
    DateTime? orderDate,
    OrderStatus? status,
    double? amountPaid,
    Map<String, String>? formData,
  }) {
    return ServiceOrder(
      id: id ?? this.id,
      serviceName: serviceName ?? this.serviceName,
      serviceCategory: serviceCategory ?? this.serviceCategory,
      customerPhone: customerPhone ?? this.customerPhone,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      amountPaid: amountPaid ?? this.amountPaid,
      formData: formData ?? this.formData,
    );
  }

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
