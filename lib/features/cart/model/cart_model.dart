import 'package:grocery_app/features/home/model/product_model.dart';

class CartModel {
  final String id;
  final String userId;
  final String productId;
  final int quantity;
  final double price;
  final ProductModel? product;
  final DateTime createdAt;

  CartModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.price,
    this.product,
    required this.createdAt,
  });

  double get totalPrice => price * quantity;

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      userId: json['user_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "product_id": productId,
      "quantity": quantity,
      "price": price,
    };
  }
}
