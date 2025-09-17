import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_app/core/routes/route_dir_name.dart';
import 'package:grocery_app/core/routes/route_name.dart';
import 'package:grocery_app/core/utils/dependancy_injection.dart';
import 'package:grocery_app/core/widgets/toast/flutter_toast.dart';
import 'package:grocery_app/features/auth/view/auth_login.dart';
import 'package:grocery_app/features/auth/view/auth_register.dart';
import 'package:grocery_app/features/auth/view/auth_welcome.dart';
import 'package:grocery_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:grocery_app/features/cart/view/cart_view.dart';
import 'package:grocery_app/features/favorite/view/favorite_view.dart';
import 'package:grocery_app/features/home/model/category_model.dart';
import 'package:grocery_app/features/home/model/product_model.dart';
import 'package:grocery_app/features/home/view/home_view.dart';
import 'package:grocery_app/features/home/view/product_details.dart';
import 'package:grocery_app/features/onboarding/views/onboarding_view.dart';
import 'package:grocery_app/features/order/model/order_model.dart';
import 'package:grocery_app/features/order/view/order_details_screen.dart';
import 'package:grocery_app/features/order/view/order_screen.dart';
import 'package:grocery_app/features/profile/category_details_screen.dart';
import 'package:grocery_app/features/profile/view/about_me.dart';
import 'package:grocery_app/features/profile/view/profile_view.dart';
import 'package:grocery_app/features/search/view/search_view.dart';
import 'package:provider/provider.dart';

part 'redirect.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: RouteDirName.authWelcome,

    redirect: (context, state) => getRedirect(context, state),
    routes: [
      GoRoute(
        name: AppRouteName.search,
        path: RouteDirName.search,
        builder: (context, state) => SearchView(),
      ),
      GoRoute(
        name: AppRouteName.categoryDetails,
        path: RouteDirName.categoryDetails,
        builder: (context, state) {
          final category = state.extra as CategoryModel;
          return CategoryDetailsScreen(category: category);
        },
      ),
      GoRoute(
        path: RouteDirName.productDetails,
        name: AppRouteName.productDetails,
        builder: (context, state) {
          final product = state.extra as ProductModel;
          return ProductDetailScreen(product: product);
        },
      ),
      GoRoute(
        name: AppRouteName.aboutMe,
        path: RouteDirName.aboutMe,
        builder: (context, state) => const AboutMeScreen(),
      ),
      GoRoute(
        name: AppRouteName.signIn,
        path: RouteDirName.signIn,
        builder: (context, state) => const SignIn(),
      ),
      GoRoute(
        name: AppRouteName.signUp,
        path: RouteDirName.signUp,
        builder: (context, state) => const SignUp(),
      ),
      GoRoute(
        name: AppRouteName.onboarding,
        path: RouteDirName.onBoarding,
        builder: (context, state) => OnboardingView(),
      ),

      GoRoute(
        name: AppRouteName.authWelcome,
        path: RouteDirName.authWelcome,
        builder: (context, state) => const AuthWelcome(),
      ),
      GoRoute(
        name: AppRouteName.orderDetails,
        path: RouteDirName.orderDetails,
        builder: (context, state) {
          final orderModel = state.extra as OrderModel;
          return OrderDetailsScreen(order: orderModel);
        },
      ),

      GoRoute(
        name: AppRouteName.home,
        path: RouteDirName.home,
        builder: (context, state) => const HomeView(),
      ),

      GoRoute(
        name: AppRouteName.cart,
        path: RouteDirName.cart,
        builder: (context, state) => const CartView(),
      ),

      GoRoute(
        name: AppRouteName.favorite,
        path: RouteDirName.favorite,
        builder: (context, state) => const FavoriteView(),
      ),

      GoRoute(
        name: AppRouteName.profile,
        path: RouteDirName.profile,
        builder: (context, state) => const ProfileView(),
      ),

      GoRoute(
        name: AppRouteName.order,
        path: RouteDirName.orders,
        builder: (context, state) => const OrderScreen(),
      ),
    ],
  );
}
