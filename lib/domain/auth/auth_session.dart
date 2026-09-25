class AuthSession {
  const AuthSession({required this.username, required this.token, this.userId});

  final int? userId;
  final String username;
  final String token;
}
