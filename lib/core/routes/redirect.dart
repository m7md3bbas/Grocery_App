part of 'app_router.dart';

FutureOr<String?> getRedirect(BuildContext context, GoRouterState state) async {
  final isAuthanticated = context.read<AuthViewModel>().authStatus;
  final login = state.matchedLocation == RouteDirName.signIn;
  final signUp = state.matchedLocation == RouteDirName.signUp;
  final authWelcome = state.matchedLocation == RouteDirName.authWelcome;

  if (isAuthanticated != AuthStatus.authenticated &&
      !login &&
      !signUp &&
      !authWelcome) {
    return RouteDirName.authWelcome;
  }

  if (isAuthanticated == AuthStatus.authenticated &&
      (login || signUp || authWelcome)) {
    return RouteDirName.home;
  }

  return null;
}
