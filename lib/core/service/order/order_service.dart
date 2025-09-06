import 'package:grocery_app/core/service/dio/base_class.dart';
import 'package:grocery_app/core/utils/error/failure.dart';
import 'package:grocery_app/features/order/model/order_items_model.dart';
import 'package:grocery_app/features/order/model/order_model.dart';

class OrderService {
  final DioBaseClient dioClient;
  String orderTable = 'orders';
  String orderItemTable = 'order_items';
  OrderService({required this.dioClient});

  Future<void> newOrder({required OrderModel order}) async {
    try {
      await dioClient.post(url: orderTable, body: order.toJson());
    } catch (e) {
      throw Failure("Failed to add order: $e");
    }
  }

  Future<void> newOrderItem({required OrderItemModel orderItem}) async {
    try {
      await dioClient.post(url: orderItemTable, body: orderItem.toJson());
    } catch (e) {
      throw Failure("Failed to add order item: $e");
    }
  }

  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      final response = await dioClient.get(
        url: orderTable,
        queryParameters: {'user_id': 'eq.$userId'},
      );

      final data = response.data as List<dynamic>;
      final orders = data.map((json) => OrderModel.fromJson(json)).toList();
      return orders;
    } catch (e) {
      throw Failure("Failed to get user orders: $e");
    }
  }

  Future<OrderItemModel?> getOrderItems(String orderId) async {
    try {
      final response = await dioClient.get(
        url: orderItemTable,
        queryParameters: {
          'order_id': 'eq.$orderId',
          'select': '*, product:product_id(*)',
        },
      );

      final data = response.data as List<dynamic>;

      if (data.isNotEmpty) {
        return OrderItemModel.fromJson(data.first);
      }
      return null;
    } catch (e) {
      throw Failure("Failed to get order items: $e");
    }
  }
}
