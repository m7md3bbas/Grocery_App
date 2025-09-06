import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_app/core/utils/constants/styles/app_color_styles.dart';
import 'package:grocery_app/core/utils/dependancy_injection.dart';
import 'package:grocery_app/core/widgets/toast/flutter_toast.dart';
import 'package:grocery_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:grocery_app/features/cart/viewmodel/cart_view_model.dart';
import 'package:grocery_app/features/favorite/viewmodel/favorite_view_model.dart';
import 'package:grocery_app/features/home/model/product_model.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;
  const ProductDetailScreen({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageHeight = size.height * 0.4;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + back + fav
            Container(
              height: imageHeight,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFE9FBE5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _iconButton(
                          Icons.arrow_back,
                          () => GoRouter.of(context).pop(),
                        ),
                        _iconButton(
                          context.watch<FavoriteViewModel>().isInFavoriteById(
                                product.id,
                              )
                              ? Icons.favorite
                              : Icons.favorite_border,
                          () {
                            final favVm = context.read<FavoriteViewModel>();
                            final userId = locator<AuthViewModel>()
                                .getCurrentUser()!
                                .id;
                            if (favVm.isInFavoriteById(product.id)) {
                              final fav = favVm.favoriteList.firstWhere(
                                (f) => f.product.id == product.id,
                              );
                              favVm
                                  .removeFromFavorite(
                                    favoriteId: fav.id,
                                    userId: userId,
                                  )
                                  .then(
                                    (_) => ShowToast.showInfo(
                                      "${product.title} removed from favorite",
                                    ),
                                  );
                            } else {
                              favVm
                                  .addToFavorite(
                                    productId: product.id,
                                    userId: userId,
                                  )
                                  .then(
                                    (_) => ShowToast.showInfo(
                                      "${product.title} added to favorite",
                                    ),
                                  );
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  Center(
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: imageHeight * 0.7,
                        maxWidth: size.width * 0.8,
                      ),
                      child: Hero(
                        tag: 'product_${product.id}',
                        child: CachedNetworkImage(
                          imageUrl: product.image!,
                          fit: BoxFit.contain,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Info
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "\$${product.price.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Weight: ${product.weight} kg",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: product.quantity > 0
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            product.quantity > 0
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: product.quantity > 0
                                ? Colors.green
                                : Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            product.quantity > 0
                                ? "${product.quantity} in stock"
                                : "Out of stock",
                            style: TextStyle(
                              color: product.quantity > 0
                                  ? Colors.green[700]
                                  : Colors.red[700],
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F8FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        product.description.toString(),
                        style: const TextStyle(
                          color: Colors.black54,
                          height: 1.5,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            // Bottom bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Consumer<CartViewModel>(
                  builder: (context, cartVm, _) {
                    final isInCart = cartVm.isInCart(product);
                    if (isInCart) {
                      final quantity = cartVm.getQuantity(product);
                      final isLoading = cartVm.isItemLoading(product.id);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _circleButton(Icons.remove, () {
                            final userId = context
                                .read<AuthViewModel>()
                                .getCurrentUser()!
                                .id;
                            if (quantity > 1) {
                              cartVm.updateQuantity(
                                productId: product.id,
                                userId: userId,
                                cartId: cartVm.getCartId(product),
                                quantity: quantity - 1,
                              );
                            } else {
                              cartVm
                                  .removeFromCart(
                                    userId,
                                    cartVm.getCartId(product),
                                    product.id,
                                  )
                                  .then(
                                    (_) => ShowToast.showError(
                                      "${product.title} removed from cart",
                                    ),
                                  );
                            }
                          }),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      color: AppColors.primary,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "$quantity",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                          ),
                          _circleButton(
                            quantity < product.quantity
                                ? Icons.add
                                : Icons.check,
                            () {
                              if (quantity < product.quantity) {
                                final userId = context
                                    .read<AuthViewModel>()
                                    .getCurrentUser()!
                                    .id;
                                cartVm.updateQuantity(
                                  productId: product.id,
                                  userId: userId,
                                  cartId: cartVm.getCartId(product),
                                  quantity: quantity + 1,
                                );
                              } else {
                                ShowToast.showError(
                                  "We have only ${product.quantity} of this product",
                                );
                              }
                            },
                          ),
                        ],
                      );
                    } else {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: product.quantity > 0
                              ? () {
                                  final userId = context
                                      .read<AuthViewModel>()
                                      .getCurrentUser()!
                                      .id;
                                  cartVm.addToCart(
                                    userId: userId,
                                    productId: product.id,
                                    quantity: 1,
                                    price: product.price,
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.shopping_cart, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                product.quantity > 0
                                    ? "Add to Cart"
                                    : "Out of Stock",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return Container(
      width: 40,
      height: 40,
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
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: AppColors.primary),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primary, size: 18),
      ),
    );
  }
}
