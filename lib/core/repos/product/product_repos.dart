import 'package:grocery_app/core/service/product/product_service.dart';
import 'package:grocery_app/features/home/model/product_model.dart';

class ProductRepos {
  final ProductService productService;

  ProductRepos({required this.productService});

  Future<List<ProductModel>> getProductsByCategory({
    required int page,
    required int pageSize,
    required String categoryId,
  }) => productService.getProductsByCategory(
    categoryId: categoryId,
    page: page,
    pageSize: pageSize,
  );

  Future<List<ProductModel>> getProducts({
    required int page,
    required int pageSize,
  }) => productService.getProducts(page: page, pageSize: pageSize);

  Future<List<ProductModel>> searchProducts({
    required String query,
    required int page,
    required int pageSize,
  }) => productService.searchProducts(
    query: query,
    page: page,
    pageSize: pageSize,
  );
}
