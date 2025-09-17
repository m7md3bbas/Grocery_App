part of 'app_router.dart';

FutureOr<String?> getRedirect(BuildContext context, GoRouterState state) async {
  final isAuthanticated = context.read<AuthViewModel>().authStatus;
  final login = state.matchedLocation == RouteDirName.signIn;

  if (isAuthanticated != AuthStatus.authenticated && !login) {
    return RouteDirName.authWelcome;
  }
  if (isAuthanticated == AuthStatus.authenticated && login) {
    return RouteDirName.home;
  }
  return null;
}
