class Tank {
  const Tank({
    required this.id,
    required this.siteId,
    required this.name,
    required this.fuelType,
    required this.capacity,
    required this.unit,
    required this.currentLevel,
    required this.status,
    required this.lastReadingAt,
  });

  final String id;
  final int siteId;
  final String name;
  final String fuelType;
  final double capacity;
  final String unit;
  final double currentLevel;
  final String status;
  final DateTime? lastReadingAt;

  int get level =>
      capacity <= 0 ? 0 : (currentLevel / capacity * 100).round().clamp(0, 100);
}
