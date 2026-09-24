class AuthSession {
  const AuthSession({
    required this.username,
    required this.token,
    this.userId,
    this.roles = const [],
    this.companyId,
    this.providerId,
  });

  final int? userId;
  final String username;
  final String token;
  final List<String> roles;
  final int? companyId;
  final int? providerId;
}
