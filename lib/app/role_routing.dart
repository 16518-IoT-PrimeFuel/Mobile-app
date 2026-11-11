import '../domain/auth/auth_session.dart';
import '../features/home/presentation/home_page.dart';

const providerRole = 'ROLE_PROVIDER';
const buyerRole = 'ROLE_BUYER';

/// Whether [session] is the offline preview session created by
/// `AuthController.continueAsGuest`.
bool isGuestSession(AuthSession? session) => session?.token == 'guest';

/// Home variant for [session]: `ROLE_PROVIDER` gets the provider home and
/// everything else the requester home.
///
/// Only the guest preview session may override the variant, through
/// [previewRole] (`?role=provider`), so every screen stays reviewable without
/// an account. Real sessions always follow their roles.
HomeRole homeRoleFor(AuthSession? session, {String? previewRole}) {
  if (isGuestSession(session)) {
    return previewRole == 'provider' ? HomeRole.provider : HomeRole.requester;
  }
  return session?.roles.contains(providerRole) ?? false
      ? HomeRole.provider
      : HomeRole.requester;
}

/// Mirrors the Angular `providerGuard` / `buyerGuard`: `/provider/**` and
/// `/dispatches/**` need `ROLE_PROVIDER`, `/orders/new` needs `ROLE_BUYER`.
/// A signed-in user without the role goes to `/home` (mobile has no
/// access-denied page). Returns `null` when the route is allowed.
///
/// Decision: the guest preview session bypasses these guards, so every screen
/// can still be previewed offline as before. Signed-out users are handled by
/// the authentication redirect, not here.
String? roleGuardRedirect(AuthSession? session, String location) {
  if (session == null || isGuestSession(session)) return null;
  final roles = session.roles;
  final providerOnly =
      _isUnder(location, '/provider') || _isUnder(location, '/dispatches');
  if (providerOnly && !roles.contains(providerRole)) return '/home';
  if (location == '/orders/new' && !roles.contains(buyerRole)) return '/home';
  return null;
}

bool _isUnder(String location, String base) =>
    location == base || location.startsWith('$base/');
