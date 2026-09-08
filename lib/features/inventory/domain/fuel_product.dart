enum ProductAvailability { available, lowStock, inactive }

class FuelProduct {
  const FuelProduct({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.availability,
  });

  final int id;
  final String name;
  final String type;
  final double price;
  final ProductAvailability availability;
}
