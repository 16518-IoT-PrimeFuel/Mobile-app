enum OrderStatus {
  pending,
  approved,
  inTransit,
  delivered,
  cancelled,
  rejected,
}

class Order {
  const Order({
    required this.id,
    required this.fuel,
    required this.quantity,
    required this.total,
    required this.status,
    this.requestId,
    this.request = false,
    this.deliveryAddress = '',
  });

  final String id;
  final String fuel;
  final double quantity;
  final double total;
  final OrderStatus status;
  final int? requestId;
  final bool request;
  final String deliveryAddress;
}
