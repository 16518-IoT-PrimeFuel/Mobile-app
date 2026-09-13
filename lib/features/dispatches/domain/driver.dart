class Driver {
  const Driver({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.licenseNumber,
    this.phoneNumber = '',
    this.email = '',
    this.status = 'AVAILABLE',
  });

  final int id;
  final String firstName;
  final String lastName;
  final String licenseNumber;
  final String phoneNumber;
  final String email;
  final String status;

  String get name => '$firstName $lastName'.trim();
}
