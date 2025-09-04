import 'dart:async';
import 'package:flutter/material.dart';
import 'package:grocery_app/core/repos/product/product_repos.dart';
import 'package:grocery_app/features/home/model/product_model.dart';

class SearchViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String _error = '';
  int _currentPage = 1;

  bool get isLoading => _isLoading;
  String get error => _error;

  final List<ProductModel> _searchProducts = [];
  List<ProductModel> get searchProducts => _searchProducts;

  final ProductRepos productRepos;

  SearchViewModel({required this.productRepos});

  Timer? _debounce;

  void searchProduct({required String query}) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () async {
      if (query.isEmpty) {
        _searchProducts.clear();
        notifyListeners();
        return;
      }

      setIsLoading(true);
      _currentPage = 1;

      try {
        final products = await productRepos.searchProducts(
          query: query,
          page: _currentPage,
          pageSize: 10,
        );

        // فلترة بعد ما ييجي الـ data من الـ API
        final filtered = products.where((product) {
          final name = product.title.toLowerCase();
          final search = query.toLowerCase();
          return name == search || name.contains(search);
        }).toList();

        _searchProducts
          ..clear()
          ..addAll(filtered);

        setIsLoading(false);
      } catch (e) {
        setError(e.toString());
      }
    });
  }

  Future<void> checkLoadMore({
    bool loadMore = false,
    required String query,
  }) async {
    if (loadMore && !_isLoading) {
      setIsLoading(true);
      _currentPage++;
      try {
        final products = await productRepos.searchProducts(
          query: query,
          page: _currentPage,
          pageSize: 3,
        );
        _searchProducts.addAll(products);
        setIsLoading(false);
      } catch (e) {
        setError(e.toString());
      }
    }
  }

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String message) {
    _isLoading = false;
    _error = message;
    notifyListeners();
  }

  bool _disposed = false;

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _debounce?.cancel();
    super.dispose();
  }
}
