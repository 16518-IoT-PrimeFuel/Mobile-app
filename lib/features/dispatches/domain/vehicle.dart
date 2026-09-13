class Vehicle {
  const Vehicle({
    required this.id,
    required this.plate,
    required this.type,
    this.brand = '',
    this.model = '',
    this.capacity = 0,
    this.status = 'AVAILABLE',
  });

  final int id;
  final String plate;
  final String type;
  final String brand;
  final String model;
  final double capacity;
  final String status;
}
