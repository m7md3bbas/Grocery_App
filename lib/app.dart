import 'package:flutter/material.dart';
import 'package:grocery_app/core/routes/app_router.dart';
import 'package:grocery_app/core/utils/dependancy_injection.dart';
import 'package:grocery_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:grocery_app/features/cart/viewmodel/cart_view_model.dart';
import 'package:grocery_app/features/favorite/viewmodel/favorite_view_model.dart';
import 'package:grocery_app/features/home/viewmodel/home_view_model.dart';
import 'package:grocery_app/features/profile/viewmodel/profile_view_model.dart';
import 'package:grocery_app/features/search/viewmodel/search_viewmodel.dart';
import 'package:provider/provider.dart';

import 'features/onboarding/viewModel/onboarding_view_model_model.dart';

class GroceryApp extends StatelessWidget {
  const GroceryApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => locator<AuthViewModel>()),
        ChangeNotifierProvider(
          create: (context) => locator<OnboardingViewModel>(),
        ),
        ChangeNotifierProvider(create: (context) => locator<HomeViewModel>()),
        ChangeNotifierProvider(
          create: (context) => locator<ProfileViewModel>(),
        ),
        ChangeNotifierProvider(create: (context) => locator<CartViewModel>()),
        ChangeNotifierProvider(create: (context) => locator<SearchViewModel>()),
        ChangeNotifierProvider(
          create: (context) => locator<FavoriteViewModel>(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
