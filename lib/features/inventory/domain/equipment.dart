class Equipment {
  const Equipment({
    required this.id,
    required this.name,
    required this.fuelType,
    required this.capacity,
    required this.currentLevel,
    required this.location,
  });

  final int id;
  final String name;
  final String fuelType;
  final double capacity;
  final double currentLevel;
  final String location;
}
