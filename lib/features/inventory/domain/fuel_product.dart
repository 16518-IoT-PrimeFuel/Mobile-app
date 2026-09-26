enum ProductAvailability { available, lowStock, inactive }

class FuelProduct {
  const FuelProduct({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.availability,
    this.unit = 'L',
    this.availableStock = 0,
    this.capacity = 0,
    this.providerId,
    this.active = true,
  });

  final int id;
  final String name;
  final String type;
  final double price;
  final ProductAvailability availability;
  final String unit;
  final double availableStock;
  final double capacity;
  final int? providerId;
  final bool active;
}
