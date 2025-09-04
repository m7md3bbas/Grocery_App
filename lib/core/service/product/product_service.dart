import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grocery_app/core/service/dio/base_class.dart';
import 'package:grocery_app/core/utils/error/failure.dart';
import 'package:grocery_app/features/home/model/product_model.dart';

class ProductService {
  final DioBaseClient dio;

  ProductService({required this.dio});

  Future<List<ProductModel>> getProducts({
    required int page,
    required int pageSize,
  }) async {
    try {
      final Dio dio = Dio();
      final start = (page - 1) * pageSize;
      final end = start + pageSize - 1;

      final response = await dio.get(
        'https://ryainsxbjgbmcfcsaklp.supabase.co/rest/v1/grocery_products',
        queryParameters: {'select': '*'},
        options: Options(
          headers: {
            'apikey': dotenv.env['SUPABASE_KEY']!,
            'Authorization': 'Bearer ${dotenv.env['SUPABASE_KEY']}',
            'Prefer': 'return=minimal',
            'Range': '$start-$end',
          },
        ),
      );

      final data = (response.data as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
      return data;
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  Future<List<ProductModel>> getProductsByCategory({
    required int page,
    required int pageSize,
    required String categoryId,
  }) async {
    try {
      final Dio dio = Dio();
      final start = (page - 1) * pageSize;
      final end = start + pageSize - 1;

      final response = await dio.get(
        'https://ryainsxbjgbmcfcsaklp.supabase.co/rest/v1/grocery_products',
        queryParameters: {'select': '*', 'category_id': 'eq.$categoryId'},
        options: Options(
          headers: {
            'apikey': dotenv.env['SUPABASE_KEY']!,
            'Authorization': 'Bearer ${dotenv.env['SUPABASE_KEY']}',
            'Prefer': 'return=minimal',
            'Range': '$start-$end',
          },
        ),
      );

      final data = (response.data as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();

      return data;
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  Future<List<ProductModel>> searchProducts({
    required String query,
    required int page,
    required int pageSize,
  }) async {
    try {
      final Dio dio = Dio();
      final start = (page - 1) * pageSize;
      final end = start + pageSize - 1;

      final response = await dio.get(
        'https://ryainsxbjgbmcfcsaklp.supabase.co/rest/v1/grocery_products',
        queryParameters: {
          'select': '*',
          if (query.isNotEmpty) 'title': 'ilike.*$query*',
        },
        options: Options(
          headers: {
            'apikey': dotenv.env['SUPABASE_KEY']!,
            'Authorization': 'Bearer ${dotenv.env['SUPABASE_KEY']}',
            'Range': '$start-$end',
          },
        ),
      );

      final data = (response.data as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
      return data;
    } catch (e) {
      throw Failure(e.toString());
    }
  }
}
