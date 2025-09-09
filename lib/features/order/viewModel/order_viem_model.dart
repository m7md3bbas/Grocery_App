import 'package:flutter/material.dart';
import 'package:grocery_app/core/service/order/order_service.dart';
import 'package:grocery_app/core/utils/dependancy_injection.dart';
import 'package:grocery_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:grocery_app/features/order/model/order_model.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderService orderService;

  OrderViewModel({required this.orderService}) {
    getOrders();
  }

  bool isLoading = false;
  String error = '';
  bool isDispose = false;

  List<OrderModel> orders = [];
  List<OrderModel> get getOrdersList => orders;

  @override
  void dispose() {
    if (!isDispose) {
      isDispose = true;
      notifyListeners();
    }
    super.dispose();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setError(String message) {
    isLoading = false;
    error = message;
    notifyListeners();
  }

  void setSuccess() {
    isLoading = false;
    error = '';
    notifyListeners();
  }

  // Fetch all orders for current user
  Future<void> getOrders() async {
    setLoading(true);
    try {
      orders = await orderService.getUserOrders(
        locator.get<AuthViewModel>().getCurrentUser()!.id,
      );
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<String?> createOrder({
    required String userId,
    required double totalPrice,
  }) async {
    setLoading(true);
    try {
      final orderId = await orderService.createOrder(
        userId: userId,
        totalPrice: totalPrice,
      );
      setLoading(false);
      return orderId;
    } catch (e) {
      setError(e.toString());
      return null;
    }
  }

  Future<void> addOrderItems({
    required String orderId,
    required List<Map<String, dynamic>> items,
  }) async {
    setLoading(true);
    try {
      await orderService.addOrderItems(orderId: orderId, items: items);
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }

  // Cancel order
  Future<void> cancelOrder(String orderId) async {
    setLoading(true);
    try {
      await orderService.cancelOrder(orderId);
      final index = orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        orders[index] = orders[index].copyWith(status: 'canceled');
      }
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }
}
