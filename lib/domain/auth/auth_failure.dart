enum AuthFailureType { invalidCredentials, network, unknown }

class AuthFailure implements Exception {
  const AuthFailure(this.type, this.message);

  final AuthFailureType type;
  final String message;

  factory AuthFailure.invalidCredentials() => const AuthFailure(
    AuthFailureType.invalidCredentials,
    'Email o contraseña incorrectos. Verifica tus credenciales o recupera tu acceso.',
  );

  factory AuthFailure.network() => const AuthFailure(
    AuthFailureType.network,
    'No pudimos conectar con FullTank. Revisa tu conexión e inténtalo de nuevo.',
  );

  factory AuthFailure.unknown() => const AuthFailure(
    AuthFailureType.unknown,
    'No pudimos iniciar sesión. Inténtalo de nuevo.',
  );

  @override
  String toString() => message;
}
