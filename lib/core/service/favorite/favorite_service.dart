import 'package:grocery_app/core/service/dio/base_class.dart';
import 'package:grocery_app/core/utils/error/failure.dart';
import 'package:grocery_app/features/favorite/model/favorite_model.dart';

class FavoriteService {
  final DioBaseClient dioBaseClient;
  String table = "user_favorites";

  FavoriteService({required this.dioBaseClient});
  Future<void> addToFavorite({
    required String productId,
    required String userId,
  }) async {
    try {
      await dioBaseClient.post(
        url: table,
        body: {"product_id": productId, "user_id": userId},
      );
    } catch (e) {
      throw Failure("Failed to add to favorite: $e");
    }
  }

  Future<void> removeFromFavorite({required String favoriteId}) async {
    try {
      await dioBaseClient.delete(
        url: table,
        queryParameters: {"id": "eq.$favoriteId"},
      );
    } catch (e) {
      throw Failure("Failed to remove from favorite: $e");
    }
  }

  Future<List<FavoriteModel>> getFavoriteProducts({
    required String userId,
  }) async {
    try {
      // 1. هات favorite ids
      final response = await dioBaseClient.get(
        url: table, // جدول favorites
        queryParameters: {
          "user_id": "eq.$userId",
          'select': '*, product:product_id(*)',
        },
      );

      final data = response.data as List<dynamic>;
      return data.map((json) => FavoriteModel.fromJson(json)).toList();
    } catch (e) {
      throw Failure("Failed to get favorite products: $e");
    }
  }
}
