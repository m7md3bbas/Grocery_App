import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_app/core/routes/route_name.dart';
import 'package:grocery_app/core/utils/constants/styles/app_color_styles.dart';
import 'package:grocery_app/core/utils/di/dependancy_injection.dart';
import 'package:grocery_app/core/widgets/toast/flutter_toast.dart';
import 'package:grocery_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:grocery_app/features/home/view/widgets/product_section.dart';
import 'package:grocery_app/features/order/model/order_items_model.dart';
import 'package:grocery_app/features/order/viewModel/order_viem_model.dart';
import 'package:grocery_app/features/payment/model/payment_model.dart';
import 'package:grocery_app/features/payment/viewmodel/payment_view_model.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/features/cart/viewmodel/cart_view_model.dart';
import 'package:grocery_app/features/cart/model/cart_model.dart';
import 'package:grocery_app/core/utils/constants/styles/app_text_style.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartViewModel>(
      builder: (context, cartVM, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Shopping Cart"),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: Colors.black,
          ),
          body: RefreshIndicator(
            color: Colors.green,
            onRefresh: () async {
              await cartVM.fetchCartItems();
            },
            child: cartVM.cartItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/home/emptyCart.png"),
                        Text("Your cart is empty", style: AppStyles.textBold20),
                        Text(
                          "Add some items to your cart",
                          style: AppStyles.textMedium12,
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(12),
                          itemCount: cartVM.cartItems.length,
                          itemBuilder: (context, index) {
                            final sortedItems = cartVM.cartItems
                              ..sort(
                                (a, b) => b.createdAt.compareTo(a.createdAt),
                              );

                            final item = sortedItems[index];
                            return GestureDetector(
                              onTap: () => context.pushNamed(
                                AppRouteName.productDetails,
                                extra: item.product,
                              ),
                              child: _buildCartItem(context, cartVM, item),
                            );
                          },
                        ),
                      ),
                      _buildSummary(cartVM, context),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    CartViewModel cartVM,
    CartModel item,
  ) {
    return Dismissible(
      key: ValueKey(item.id),
      onDismissed: (_) {
        context.read<CartViewModel>().removeLocal(item.id);
        cartVM.removeFromCart(item.id, item.productId);
      },

      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,

        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          leading: CachedNetworkImage(
            imageUrl: item.product!.image!,
            errorWidget: (ctx, url, error) =>
                const Icon(Icons.broken_image, color: Colors.grey),
            placeholder: (ctx, url) => const LoadingGridItem(),
            width: 50,
            height: 50,
          ),
          title: Text(
            item.product!.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("\$${item.price} • Qty: ${item.quantity}"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  if (item.quantity > 1) {
                    cartVM.updateQuantity(
                      productId: item.productId,
                      cartId: item.id,
                      quantity: item.quantity - 1,
                    );
                  }
                },
                icon: const Icon(Icons.remove),
              ),
              cartVM.isItemLoading(item.productId)
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: AppColors.primaryDark,
                        strokeWidth: 4,
                      ),
                    )
                  : Text(
                      item.quantity.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
              IconButton(
                onPressed: () {
                  if (item.quantity < item.product!.quantity) {
                    cartVM.updateQuantity(
                      productId: item.productId,
                      cartId: item.id,
                      quantity: item.quantity + 1,
                    );
                  } else {
                    ShowToast.showError(
                      "we have only ${item.product!.quantity} of this product",
                    );
                  }
                },
                icon: const Icon(Icons.add, color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(CartViewModel cartVM, BuildContext context) {
    final subtotal = cartVM.cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    const shipping = 5.0;
    final total = subtotal + shipping;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _buildSummaryRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}"),
          _buildSummaryRow(
            "Shipping charges",
            "\$${shipping.toStringAsFixed(2)}",
          ),
          const Divider(),
          _buildSummaryRow(
            "Total",
            "\$${total.toStringAsFixed(2)}",
            isTotal: true,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              final orderId = await context.read<OrderViewModel>().createOrder(
                totalPrice: total,
              );

              if (orderId != null) {
                await context.read<OrderViewModel>().addOrderItems(
                  orderId: orderId,
                  items: cartVM.cartItems
                      .map(
                        (item) => OrderItemModel(
                          orderId: orderId,
                          productId: item.productId,
                          quantity: item.quantity,
                          price: item.price,
                        ),
                      )
                      .toList(),
                );
              }

              await context
                  .read<PaymentViewModel>()
                  .newPayment(
                    payment: PaymentModel(
                      orderId: orderId!,
                      userId: locator<AuthViewModel>().getCurrentUser()!.id,
                      amount: total,
                      method: "cash",
                      status: "Paid",
                    ),
                  )
                  .then((value) {
                    if (value) {
                      context
                          .read<OrderViewModel>()
                          .updateOrderStatus(
                            orderId: orderId,
                            status: "Completed",
                            paymentStatus: "Paid",
                          )
                          .then(
                            (value) => ShowToast.showSuccess("Payment success"),
                          )
                          .then(
                            (value) =>
                                context.read<CartViewModel>().clearCart(),
                          );
                    } else {
                      ShowToast.showError("Payment canceled");
                    }
                  });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Checkout",
              style: AppStyles.textBold15.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
