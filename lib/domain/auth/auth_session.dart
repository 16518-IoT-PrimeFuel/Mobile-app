class AuthSession {
  const AuthSession({
    required this.username,
    required this.token,
    this.userId,
    this.companyId,
    this.providerId,
    this.roles = const [],
    this.memberships = const [],
  });

  final int? userId;
  final int? companyId;
  final int? providerId;
  final String username;
  final String token;
  final List<String> roles;
  final List<Map<String, Object?>> memberships;
}
