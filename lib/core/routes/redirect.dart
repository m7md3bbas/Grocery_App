part of 'app_router.dart';

FutureOr<String?> getRedirect(BuildContext context, GoRouterState state) async {
  final isAuthanticated = context.read<AuthViewModel>().getCurrentUser();
  final login = state.matchedLocation == RouteDirName.signIn;
  final signUp = state.matchedLocation == RouteDirName.signUp;
  final authWelcome = state.matchedLocation == RouteDirName.authWelcome;
  final onboarding = state.matchedLocation == RouteDirName.onBoarding;
  final seenOnBoarding = await SharedPref.isSeenOnboarding();
  if (!seenOnBoarding) return RouteDirName.onBoarding;

  if (isAuthanticated == null && !login && !signUp && !authWelcome) {
    GoogleSignIn().signOut();
    return RouteDirName.authWelcome;
  }

  if (isAuthanticated != null &&
      (login || signUp || authWelcome || onboarding)) {
    return RouteDirName.home;
  }

  return null;
}
