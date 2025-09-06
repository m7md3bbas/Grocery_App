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
import 'package:grocery_app/core/service/product/product_service.dart';
import 'package:grocery_app/core/service/profile/profile_service.dart';
import 'package:grocery_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:grocery_app/features/cart/viewmodel/cart_view_model.dart';
import 'package:grocery_app/features/favorite/viewmodel/favorite_view_model.dart';
import 'package:grocery_app/features/home/viewmodel/home_view_model.dart';
import 'package:grocery_app/features/onboarding/viewModel/onboarding_view_model_model.dart';
import 'package:grocery_app/features/order/viewModel/order_viem_model.dart';
import 'package:grocery_app/features/profile/viewmodel/profile_view_model.dart';
import 'package:grocery_app/features/search/viewmodel/search_viewmodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final locator = GetIt.instance;

void setupLocator() {
  // ============ Core ============ //
  locator.registerFactory<SupabaseClient>(() => Supabase.instance.client);
  locator.registerFactory<DioBaseClient>(() => DioBaseClient(dio: Dio()));

  // ============ Services ============ //
  locator.registerFactory<AuthService>(
    () => AuthServiceImp(supabaseClient: locator<SupabaseClient>()),
  );
  locator.registerFactory<ProfileService>(
    () => ProfileService(
      dio: locator<DioBaseClient>(),
      supabaseClient: locator<SupabaseClient>(),
    ),
  );
  locator.registerFactory<ProductService>(
    () => ProductService(dio: locator<DioBaseClient>()),
  );
  locator.registerFactory<CategoryService>(
    () => CategoryService(dio: locator<DioBaseClient>()),
  );
  locator.registerFactory<CartService>(
    () => CartService(dioClient: locator<DioBaseClient>()),
  );
  locator.registerFactory<FavoriteService>(
    () => FavoriteService(dioBaseClient: locator<DioBaseClient>()),
  );
  locator.registerFactory<OrderService>(
    () => OrderService(dioClient: locator<DioBaseClient>()),
  );

  // ============ Repos ============ //
  locator.registerFactory<ProfileRepo>(
    () => ProfileRepo(profileService: locator<ProfileService>()),
  );
  locator.registerFactory<ProductRepos>(
    () => ProductRepos(productService: locator<ProductService>()),
  );
  locator.registerFactory<AuthRepo>(
    () => AuthRepo(authService: locator<AuthService>()),
  );
  locator.registerFactory<CartRepo>(() => CartRepo(locator<CartService>()));
  locator.registerFactory<CategoryRepo>(
    () => CategoryRepo(categoryService: locator<CategoryService>()),
  );
  locator.registerFactory<FavoriteRepo>(
    () => FavoriteRepo(favoriteService: locator<FavoriteService>()),
  );

  // ============ ViewModels ============ //
  // 🟢 Singletons (طول التطبيق)
  locator.registerLazySingleton<AuthViewModel>(
    () => AuthViewModel(authRepo: locator<AuthRepo>()),
  );
  locator.registerLazySingleton<CartViewModel>(
    () => CartViewModel(locator<CartRepo>()),
  );
  locator.registerLazySingleton<ProfileViewModel>(
    () => ProfileViewModel(profileRepo: locator<ProfileRepo>()),
  );
  locator.registerLazySingleton<FavoriteViewModel>(
    () => FavoriteViewModel(favoriteRepo: locator<FavoriteRepo>()),
  );
  locator.registerLazySingleton<OnboardingViewModel>(
    () => OnboardingViewModel(),
  );

  // 🟡 Factories (لكل شاشة Instance جديد)
  locator.registerFactory<HomeViewModel>(
    () => HomeViewModel(
      productRepos: locator<ProductRepos>(),
      categoryRepos: locator<CategoryRepo>(),
    ),
  );
  locator.registerFactory(
    () => OrderViemModel(orderService: locator<OrderService>()),
  );
  locator.registerFactory<SearchViewModel>(
    () => SearchViewModel(productRepos: locator<ProductRepos>()),
  );
}
