import 'package:flutter/material.dart';
import 'package:grocery_app/core/repos/cart/cart_repo.dart';
import 'package:grocery_app/features/cart/model/cart_model.dart';
import 'package:grocery_app/features/home/model/product_model.dart';

class CartViewModel extends ChangeNotifier {
  final CartRepo _cartRepo;

  CartViewModel(this._cartRepo) {
    fetchCartItems();
  }

  bool _isLoading = false;
  String _error = '';
  List<CartModel> _cartItems = [];

  final Map<String, bool> _itemLoading = {};

  bool get isLoading => _isLoading;
  String get error => _error;
  List<CartModel> get cartItems => _cartItems;

  bool isItemLoading(String productId) {
    return _itemLoading[productId] ?? false;
  }

  Future<void> fetchCartItems() async {
    _isLoading = true;
    notifyListeners();
    try {
      _cartItems = await _cartRepo.getUserCart();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> addToCart({
    required String productId,
    required int quantity,
    required double price,
  }) async {
    _setItemLoading(productId, true);
    try {
      await _cartRepo.addToCart(
        productId: productId,
        quantity: quantity,
        price: price,
      );

      await fetchCartItems();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setItemLoading(productId, false);
    }
  }

  Future<void> updateQuantity({
    required String cartId,
    required String productId,
    required int quantity,
  }) async {
    _setItemLoading(productId, true);
    try {
      await _cartRepo.updateQuantity(cartId: cartId, quantity: quantity);
      await fetchCartItems();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setItemLoading(productId, false);
    }
  }

  int getQuantity(ProductModel product) {
    int quantity = 0;
    final index = _cartItems.indexWhere((p) => p.productId == product.id);
    if (index != -1) {
      quantity = _cartItems[index].quantity;
    }
    return quantity;
  }

  String getCartId(ProductModel product) {
    String cartId = '';
    final index = _cartItems.indexWhere((p) => p.productId == product.id);
    if (index != -1) {
      cartId = _cartItems[index].id;
    }
    return cartId;
  }

  bool isInCart(ProductModel product) {
    final index = _cartItems.indexWhere((p) => p.productId == product.id);
    return index != -1;
  }

  Future<void> removeFromCart(String cartId, String productId) async {
    _setItemLoading(productId, true);
    try {
      await _cartRepo.removeFromCart(cartId);
      _cartItems.removeWhere((item) => item.id == cartId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setItemLoading(productId, false);
    }
  }

  void removeLocal(String cartId) {
    _cartItems.removeWhere((item) => item.id == cartId);
    notifyListeners();
  }

  Future<void> clearCart() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _cartRepo.clearCart().then((value) => _cartItems = []);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _setItemLoading(String productId, bool value) {
    _itemLoading[productId] = value;
    notifyListeners();
  }
}
