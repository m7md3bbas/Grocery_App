import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:grocery_app/core/repos/auth/authrepo.dart';
import 'package:grocery_app/core/repos/cart/cart_repo.dart';
import 'package:grocery_app/core/repos/category/category_repo.dart';
import 'package:grocery_app/core/repos/favorite/favorite_repo.dart';
import 'package:grocery_app/core/repos/product/product_repos.dart';
import 'package:grocery_app/core/repos/profile/profile_repo.dart';
import 'package:grocery_app/core/service/auth/auth_service.dart';
import 'package:grocery_app/core/service/cart/cart_service.dart';
import 'package:grocery_app/core/service/category/category_service.dart';
import 'package:grocery_app/core/service/dio/base_class.dart';
import 'package:grocery_app/core/service/favorite/favorite_service.dart';
import 'package:grocery_app/core/service/order/order_service.dart';
import 'package:grocery_app/core/service/payment/payment_service.dart';
import 'package:grocery_app/core/service/product/product_service.dart';
import 'package:grocery_app/core/service/profile/profile_service.dart';
import 'package:grocery_app/core/utils/payment/payment_manager.dart';
import 'package:grocery_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:grocery_app/features/cart/viewmodel/cart_view_model.dart';
import 'package:grocery_app/features/favorite/viewmodel/favorite_view_model.dart';
import 'package:grocery_app/features/home/viewmodel/home_view_model.dart';
import 'package:grocery_app/features/onboarding/viewModel/onboarding_view_model_model.dart';
import 'package:grocery_app/features/order/viewModel/order_viem_model.dart';
import 'package:grocery_app/features/payment/viewmodel/payment_view_model.dart';
import 'package:grocery_app/features/profile/viewmodel/profile_view_model.dart';
import 'package:grocery_app/features/search/viewmodel/search_viewmodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Core
  locator.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  locator.registerLazySingleton<DioBaseClient>(() => DioBaseClient(dio: Dio()));

  // Services
  locator.registerLazySingleton<AuthService>(
    () => AuthServiceImp(supabaseClient: locator<SupabaseClient>()),
  );
  locator.registerLazySingleton<ProfileService>(
    () => ProfileService(
      dio: locator<DioBaseClient>(),
      supabaseClient: locator<SupabaseClient>(),
    ),
  );
  locator.registerLazySingleton<ProductService>(
    () => ProductService(dio: locator<DioBaseClient>()),
  );
  locator.registerLazySingleton<CategoryService>(
    () => CategoryService(dio: locator<DioBaseClient>()),
  );
  locator.registerLazySingleton<CartService>(
    () => CartService(dioClient: locator<DioBaseClient>()),
  );
  locator.registerLazySingleton<FavoriteService>(
    () => FavoriteService(dioBaseClient: locator<DioBaseClient>()),
  );
  locator.registerLazySingleton<OrderService>(
    () => OrderService(dioClient: locator<DioBaseClient>()),
  );
  locator.registerLazySingleton<PaymentService>(
    () => PaymentService(dioBaseClient: locator<DioBaseClient>()),
  );

  // Repos
  locator.registerLazySingleton<ProfileRepo>(
    () => ProfileRepo(profileService: locator<ProfileService>()),
  );
  locator.registerLazySingleton<ProductRepos>(
    () => ProductRepos(productService: locator<ProductService>()),
  );
  locator.registerLazySingleton<AuthRepo>(
    () => AuthRepo(authService: locator<AuthService>()),
  );
  locator.registerLazySingleton<CartRepo>(
    () => CartRepo(locator<CartService>()),
  );
  locator.registerLazySingleton<CategoryRepo>(
    () => CategoryRepo(categoryService: locator<CategoryService>()),
  );
  locator.registerLazySingleton<FavoriteRepo>(
    () => FavoriteRepo(favoriteService: locator<FavoriteService>()),
  );

  // ViewModels
  locator.registerFactory<AuthViewModel>(
    () => AuthViewModel(authRepo: locator<AuthRepo>()),
  );
  locator.registerFactory<CartViewModel>(
    () => CartViewModel(locator<CartRepo>()),
  );
  locator.registerFactory<ProfileViewModel>(
    () => ProfileViewModel(profileRepo: locator<ProfileRepo>()),
  );
  locator.registerLazySingleton<FavoriteViewModel>(
    () => FavoriteViewModel(favoriteRepo: locator<FavoriteRepo>()),
  );
  locator.registerLazySingleton<OnboardingViewModel>(
    () => OnboardingViewModel(),
  );
  locator.registerFactory<HomeViewModel>(
    () => HomeViewModel(
      productRepos: locator<ProductRepos>(),
      categoryRepos: locator<CategoryRepo>(),
    ),
  );
  locator.registerFactory<OrderViewModel>(
    () => OrderViewModel(orderService: locator<OrderService>()),
  );
  locator.registerLazySingleton<PaymentManager>(() => PaymentManager());
  locator.registerFactory<PaymentViewModel>(
    () => PaymentViewModel(
      paymentManager: locator<PaymentManager>(),
      paymentService: locator<PaymentService>(),
    ),
  );
  locator.registerFactory<SearchViewModel>(
    () => SearchViewModel(productRepos: locator<ProductRepos>()),
  );
}
