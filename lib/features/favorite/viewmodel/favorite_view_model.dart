import 'package:flutter/material.dart';
import 'package:grocery_app/core/repos/favorite/favorite_repo.dart';
import 'package:grocery_app/core/utils/dependancy_injection.dart';
import 'package:grocery_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:grocery_app/features/favorite/model/favorite_model.dart';

class FavoriteViewModel extends ChangeNotifier {
  final FavoriteRepo favoriteRepo;
  FavoriteViewModel({required this.favoriteRepo}) {
    getFavorite(userId: locator<AuthViewModel>().getCurrentUser()!.id);
  }

  bool isLoading = false;
  String error = '';
  List<FavoriteModel> favoriteList = [];

  Future<void> getFavorite({required String userId}) async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await favoriteRepo.getFavorite(userId: userId);
      favoriteList = result;
      error = '';
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToFavorite({
    required String productId,
    required String userId,
  }) async {
    try {
      await favoriteRepo.addToFavorite(productId: productId, userId: userId);
      await getFavorite(userId: userId); // refresh list
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeFromFavorite({
    required String favoriteId,
    required String userId,
  }) async {
    try {
      final oldList = List<FavoriteModel>.from(favoriteList);

      favoriteList.removeWhere((f) => f.id == favoriteId);
      notifyListeners();

      await favoriteRepo.removeFromFavorite(favoriteId: favoriteId);
    } catch (e) {
      error = e.toString();
      notifyListeners();
      await getFavorite(userId: userId);
    }
  }

  bool isInFavoriteById(String productId) {
    return favoriteList.indexWhere((f) => f.product.id == productId) != -1;
  }
}
