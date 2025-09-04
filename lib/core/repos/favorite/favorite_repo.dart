import 'package:grocery_app/core/service/favorite/favorite_service.dart';
import 'package:grocery_app/features/favorite/model/favorite_model.dart';

class FavoriteRepo {
  final FavoriteService favoriteService;

  FavoriteRepo({required this.favoriteService});

  Future<void> addToFavorite({
    required String productId,
    required String userId,
  }) async {
    await favoriteService.addToFavorite(productId: productId, userId: userId);
  }

  Future<void> removeFromFavorite({required String favoriteId}) async {
    await favoriteService.removeFromFavorite(favoriteId: favoriteId);
  }

  Future<List<FavoriteModel>> getFavorite({required String userId}) async {
    return await favoriteService.getFavoriteProducts(userId: userId);
  }
}
