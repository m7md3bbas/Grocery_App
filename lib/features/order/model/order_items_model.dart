import 'package:grocery_app/features/home/model/product_model.dart';

class OrderItemModel {
  final String? id;
  final String orderId;
  final String? productId;
  final ProductModel? product;
  final int quantity;
  final double price;
  final DateTime? createdAt;

  OrderItemModel({
    this.id,
    required this.orderId,
    this.productId,
    this.product,
    required this.quantity,
    required this.price,
    this.createdAt,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'order_id': orderId,
    'product_id': productId,
    'quantity': quantity,
    'price': price,
  };
}
