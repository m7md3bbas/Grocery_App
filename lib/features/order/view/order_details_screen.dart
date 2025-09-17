import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_app/core/widgets/toast/flutter_toast.dart';
import 'package:grocery_app/features/order/model/order_model.dart';
import 'package:grocery_app/features/order/viewModel/order_viem_model.dart';
import 'package:grocery_app/features/payment/model/payment_model.dart';
import 'package:grocery_app/features/payment/viewmodel/payment_view_model.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;
  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        leading: BackButton(onPressed: context.pop),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order #${order.orderNumber}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Status: ${order.status}",
              style: TextStyle(
                fontSize: 14,
                color: order.status.toLowerCase() == "pending"
                    ? Colors.orange
                    : Colors.green,
              ),
            ),
            const Divider(height: 32),

            const Text(
              "Items:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            if (order.orderItems.isEmpty)
              const Center(child: Text("No items in this order"))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: order.orderItems.length + 1, // +1 عشان الزرار
                  itemBuilder: (context, index) {
                    if (index < order.orderItems.length) {
                      final item = order.orderItems[index];
                      return ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: item.product?.image ?? '',
                          width: 50,
                          height: 50,
                          errorWidget: (_, __, ___) =>
                              const Icon(Icons.image_not_supported),
                        ),
                        title: Text(item.product?.title ?? "Deleted product"),
                        subtitle: Text("Qty: ${item.quantity}"),
                        trailing: Text(
                          "\$${(item.price * item.quantity).toStringAsFixed(2)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    } else {
                      // الزرار بعد آخر أيتم
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await context
                                .read<PaymentViewModel>()
                                .newPayment(
                                  payment: PaymentModel(
                                    orderId: order.id,
                                    userId: order.userId,
                                    amount: order.totalPrice,
                                    method: "Credit Card",
                                    status: "Paid",
                                  ),
                                )
                                .then((value) {
                                  if (value) {
                                    context
                                        .read<OrderViewModel>()
                                        .updateOrderStatus(
                                          orderId: order.id,
                                          status: "Completed",
                                          paymentStatus: "Paid",
                                        )
                                        .then(
                                          (value) => ShowToast.showSuccess(
                                            "Payment success",
                                          ),
                                        )
                                        .then((_) => context.pop());
                                  } else {
                                    ShowToast.showError(
                                      "Payment Failed or Canceled",
                                    );
                                  }
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text(
                            "Checkout",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),

            const SizedBox(height: 20),
            if (order.status.toLowerCase() == "pending")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    context
                        .read<OrderViewModel>()
                        .cancelOrder(order.id)
                        .then((_) => ShowToast.showSuccess("Order canceled"));
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text(
                    "Cancel Order",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
