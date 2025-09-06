import 'package:flutter/material.dart';
import 'package:grocery_app/core/service/order/order_service.dart';
import 'package:grocery_app/core/utils/dependancy_injection.dart';
import 'package:grocery_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:grocery_app/features/order/model/order_items_model.dart';
import 'package:grocery_app/features/order/model/order_model.dart';

class OrderViemModel extends ChangeNotifier {
  final OrderService orderService;

  OrderViemModel({required this.orderService}) {
    getOrders();
  }

  bool isLoading = false;
  String error = '';
  bool isDispose = false;
  @override
  void dispose() {
    if (!isDispose) {
      isDispose = true;
      notifyListeners();
    }

    super.dispose();
  }

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  setError(String message) {
    isLoading = false;
    error = message;
    notifyListeners();
  }

  setSuccess() {
    isLoading = false;
    error = '';
    notifyListeners();
  }

  List<OrderModel> orders = [];
  List<OrderModel> get getOrdersList => orders;

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

  OrderItemModel? orderItem;
  OrderModel? currentOrder;

  Future<void> getOrderItems({required String orderId}) async {
    setLoading(true);
    try {
      orderItem = await orderService.getOrderItems(orderId);
      currentOrder = orders.firstWhere(
        (o) => o.id == orderId,
        orElse: () => OrderModel(
          id: orderId,
          userId: '',
          totalPrice: 0,
          status: 'Unknown',
          orderNumber: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }
}
