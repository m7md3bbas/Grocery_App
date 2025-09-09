import 'package:grocery_app/features/order/model/order_items_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final double totalPrice;
  final String status;
  final String paymentStatus;
  final num orderNumber;
  final List<OrderItemModel> orderItems;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.totalPrice,
    required this.status,
    required this.paymentStatus,
    required this.orderNumber,
    required this.orderItems,
    required this.createdAt,
    required this.updatedAt,
  });

  OrderModel copyWith({
    String? id,
    String? userId,
    double? totalPrice,
    String? status,
    String? paymentStatus,
    num? orderNumber,
    List<OrderItemModel>? orderItems,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      orderNumber: orderNumber ?? this.orderNumber,
      orderItems: orderItems ?? this.orderItems,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['order_items'] as List<dynamic>? ?? [];
    return OrderModel(
      id: json['id'],
      userId: json['user_id'],
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'],
      paymentStatus: json['payment_status'],
      orderNumber: json['order_number'],
      orderItems: itemsJson.map((e) => OrderItemModel.fromJson(e)).toList(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'total_price': totalPrice,
    'status': status,
    'payment_status': paymentStatus,
  };
}
