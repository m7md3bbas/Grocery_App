import 'package:grocery_app/core/service/cart/cart_service.dart';
import 'package:grocery_app/features/cart/model/cart_model.dart';

class CartRepo {
  final CartService _cartService;

  CartRepo(this._cartService);

  Future<List<CartModel>> getUserCart() => _cartService.getUserCart();

  Future<void> addToCart({
    required String productId,
    required int quantity,
    required double price,
  }) => _cartService.addToCart(
    productId: productId,
    quantity: quantity,
    price: price,
  );

  Future<void> updateQuantity({
    required String cartId,
    required int quantity,
  }) => _cartService.updateQuantity(cartId: cartId, quantity: quantity);

  Future<void> removeFromCart(String cartId) =>
      _cartService.removeFromCart(cartId);

  Future<void> clearCart() => _cartService.clearCart();
}
