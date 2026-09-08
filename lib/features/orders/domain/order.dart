enum OrderStatus { pending, approved, inTransit, delivered, rejected }

class Order {
  const Order({
    required this.id,
    required this.fuel,
    required this.quantity,
    required this.total,
    required this.status,
  });

  final String id;
  final String fuel;
  final double quantity;
  final double total;
  final OrderStatus status;
}
