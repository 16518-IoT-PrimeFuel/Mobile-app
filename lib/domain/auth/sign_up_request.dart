enum BusinessRole { buyer, provider }

class SignUpRequest {
  const SignUpRequest({
    required this.username,
    required this.password,
    required this.role,
    required this.businessName,
    required this.ruc,
    required this.address,
    required this.phone,
    this.sector,
    this.contactEmail,
    this.fuelTypesOffered = const ['DIESEL'],
    this.description,
  });

  final String username;
  final String password;
  final BusinessRole role;
  final String businessName;
  final String ruc;
  final String address;
  final String phone;
  final String? sector;
  final String? contactEmail;
  final List<String> fuelTypesOffered;
  final String? description;
}
