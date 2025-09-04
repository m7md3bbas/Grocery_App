import 'package:equatable/equatable.dart';
import 'package:grocery_app/features/home/model/product_model.dart';

class FavoriteModel extends Equatable {
  final String id;
  final String productId;
  final ProductModel product;
  final String userId;
  final DateTime createdAt;

  const FavoriteModel({
    required this.productId,
    required this.id,
    required this.product,
    required this.userId,
    required this.createdAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'],
      productId: json['product_id'],
      product: ProductModel.fromJson(json['product']), // joined product
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'product_id': product.id,
    'user_id': userId,
  };

  @override
  List<Object?> get props => [id, product.id, userId, createdAt];
}
