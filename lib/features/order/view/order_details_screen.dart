import 'package:flutter/material.dart';
import 'package:grocery_app/features/order/viewModel/order_viem_model.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<OrderViemModel>().getOrderItems(orderId: widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderViemModel>(
      builder: (context, vm, child) {
        final order = vm.currentOrder;
        final item = vm.orderItem;
        final status = order?.status ?? "Unknown";
        final total = order?.totalPrice ?? 0.0;

        if (vm.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (vm.error.isNotEmpty) {
          return Scaffold(body: Center(child: Text(vm.error)));
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Order Details")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Order #${order?.orderNumber ?? widget.orderId}"),
                const SizedBox(height: 8),
                Text(
                  "Status: $status",
                  style: TextStyle(
                    fontSize: 14,
                    color: status == "Pending" ? Colors.orange : Colors.green,
                  ),
                ),
                const Divider(height: 32),
                const Text(
                  "Item:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (item == null)
                  const Center(child: Text("No item in this order"))
                else
                  ListTile(
                    title: Text(item.product.title),
                    subtitle: Text("Qty: ${item.quantity}"),
                    trailing: Text(
                      "\$${(item.quantity * item.price).toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "\$${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (status == "Pending")
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: cancel order logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Order canceled")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text("Cancel Order"),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
