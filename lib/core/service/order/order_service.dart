import 'package:dio/dio.dart';
import 'package:grocery_app/core/service/dio/base_class.dart';
import 'package:grocery_app/core/utils/dependancy_injection.dart';
import 'package:grocery_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:grocery_app/features/order/model/order_model.dart';

class OrderService {
  final DioBaseClient dioClient;
  final userId = locator<AuthViewModel>().getCurrentUser()!.id;
  OrderService({required this.dioClient});

  Future<List<OrderModel>> getUserOrders() async {
    final response = await dioClient.get(
      url: 'orders',
      queryParameters: {
        'user_id': 'eq.$userId',
        'select': '*, order_items(*, product:product_id(*))',
        'order': 'created_at.desc',
      },
    );

    final data = response.data as List<dynamic>;
    return data.map((json) => OrderModel.fromJson(json)).toList();
  }

  Future<String?> createOrder({required double totalPrice}) async {
    final response = await dioClient.post(
      url: 'orders?select=id',
      options: Options(headers: {'Prefer': 'return=representation'}),
      body: {
        'user_id': userId,
        'total_price': totalPrice,
        'status': 'pending',
        'payment_status': 'unpaid',
      },
    );

    final orderData = response.data[0];
    final orderId = orderData['id'];

    return orderId;
  }

  Future<void> addOrderItems({
    required String orderId,
    required List<Map<String, dynamic>> items,
  }) async {
    for (var item in items) {
      await dioClient.post(
        url: 'order_items',
        body: {
          'order_id': orderId,
          'product_id': item['product_id'],
          'quantity': item['quantity'],
          'price': item['price'],
        },
      );
    }
  }

  Future<void> updateOrder(
    String status,
    String orderId,
    String paymentStatus,
  ) async {
    await dioClient.patch(
      url: 'orders',
      queryParameters: {'id': 'eq.$orderId'},
      data: {'status': status, 'payment_status': paymentStatus},
    );
  }

  Future<void> cancelOrder(String orderId) async {
    await dioClient.patch(
      url: 'orders',
      queryParameters: {'id': 'eq.$orderId'},
      data: {'status': 'canceled'},
    );
  }
}
