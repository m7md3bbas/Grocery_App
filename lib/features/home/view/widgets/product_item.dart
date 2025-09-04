import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_app/core/routes/app_router.dart';
import 'package:grocery_app/core/utils/constants/styles/app_color_styles.dart';
import 'package:grocery_app/core/utils/constants/styles/app_text_style.dart';
import 'package:grocery_app/core/utils/dependancy_injection.dart';
import 'package:grocery_app/core/widgets/toast/flutter_toast.dart';
import 'package:grocery_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:grocery_app/features/cart/viewmodel/cart_view_model.dart';
import 'package:grocery_app/features/favorite/viewmodel/favorite_view_model.dart';
import 'package:grocery_app/features/home/model/product_model.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;
  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => GoRouter.of(
        context,
      ).push(AppRouteName.productDetails, extra: product),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (product.isNew) _statusItem(),
                const Spacer(),
                _wishListItem(context),
              ],
            ),
            CachedNetworkImage(
              imageUrl:
                  "https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?q=80&w=880&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              height: 90,
            ),
            const SizedBox(height: 8),
            Text(
              "\$${product.price.toStringAsFixed(2)}",
              style: AppStyles.textBold15.copyWith(color: AppColors.primary),
            ),
            Text(
              product.title,
              style: AppStyles.textBold15.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              "${product.weight} ${product.unit}",
              style: AppStyles.textMedium12.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 8),

            context.watch<CartViewModel>().isInCart(product)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _circleButton(
                        Icons.remove,
                        () => _handleDecrease(context, product),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child:
                            context.watch<CartViewModel>().isItemLoading(
                              product.id,
                            )
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: const CircularProgressIndicator(
                                  color: AppColors.primary,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                "${context.watch<CartViewModel>().getQuantity(product)}",
                                style: AppStyles.textBold20.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                      ),
                      context.watch<CartViewModel>().getQuantity(product) <
                              product.quantity
                          ? _circleButton(
                              Icons.add,
                              () => _handleIncrease(context, product),
                            )
                          : _circleButton(Icons.done, () {}),
                    ],
                  )
                : TextButton(
                    onPressed: () => _handleAddToCart(context, product),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_cart, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          "Add to cart",
                          style: AppStyles.textMedium15.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _statusItem() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xffFDEFD5),
      ),
      child: Text("New", style: AppStyles.textMedium12),
    );
  }

  Widget _wishListItem(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleToggleFavorite(product, context),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.7),
        ),
        child: context.watch<FavoriteViewModel>().isInFavoriteById(product.id)
            ? const Icon(Icons.favorite, color: AppColors.primary)
            : const Icon(Icons.favorite_border, color: AppColors.primary),
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: AppColors.primary.withOpacity(0.1),
        child: Icon(icon, color: AppColors.primary),
      ),
    );
  }

  Future<void> _handleAddToCart(
    BuildContext context,
    ProductModel product,
  ) async {
    await context
        .read<CartViewModel>()
        .addToCart(
          userId: context.read<AuthViewModel>().getCurrentUser()!.id,
          productId: product.id,
          quantity: context.read<CartViewModel>().getQuantity(product) + 1,
          price: product.price,
        )
        .then(
          (value) => value
              ? ShowToast.showInfo("${product.title} Added to cart")
              : ShowToast.showError("${product.title} Failed to add to cart"),
        );
  }

  void _handleIncrease(BuildContext context, ProductModel product) {
    final userId = locator<AuthViewModel>().getCurrentUser()!.id;
    final cartVm = context.read<CartViewModel>();
    final currentQuantity = cartVm.getQuantity(product);

    if (currentQuantity < product.quantity) {
      cartVm.updateQuantity(
        productId: product.id,
        userId: userId,
        cartId: cartVm.getCartId(product),
        quantity: currentQuantity + 1,
      );
    } else {
      ShowToast.showError("We have only ${product.quantity} of this product");
    }
  }

  void _handleDecrease(BuildContext context, ProductModel product) {
    final userId = locator<AuthViewModel>().getCurrentUser()!.id;
    final cartVm = context.read<CartViewModel>();
    final currentQuantity = cartVm.getQuantity(product);

    if (currentQuantity > 1) {
      cartVm.updateQuantity(
        productId: product.id,
        userId: userId,
        cartId: cartVm.getCartId(product),
        quantity: currentQuantity - 1,
      );
    } else if (currentQuantity == 1) {
      cartVm.removeFromCart(userId, cartVm.getCartId(product), product.id).then(
        (_) {
          ShowToast.showError("${product.title} removed from cart");
        },
      );
    }
  }

  void _handleToggleFavorite(ProductModel product, BuildContext context) async {
    final favoriteVM = context.read<FavoriteViewModel>();
    final userId = locator<AuthViewModel>().getCurrentUser()!.id;

    if (favoriteVM.isInFavoriteById(product.id)) {
      final favorite = favoriteVM.favoriteList.firstWhere(
        (f) => f.product.id == product.id,
      );

      await favoriteVM
          .removeFromFavorite(favoriteId: favorite.id, userId: userId)
          .then(
            (_) => ShowToast.showInfo("${product.title} removed from favorite"),
          );
    } else {
      await favoriteVM
          .addToFavorite(productId: product.id, userId: userId)
          .then(
            (_) => ShowToast.showInfo("${product.title} added to favorite"),
          );
    }
  }
}
