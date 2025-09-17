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
    return OrderModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      status: json['status']?.toString() ?? 'pending',
      paymentStatus: json['payment_status']?.toString() ?? 'unpaid',
      orderNumber: json['order_number'] ?? 0,
      orderItems: (json['order_items'] as List<dynamic>? ?? [])
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'total_price': totalPrice,
    'status': status,
    'payment_status': paymentStatus,
  };
}
