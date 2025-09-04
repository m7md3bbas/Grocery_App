import 'package:grocery_app/core/service/category/category_service.dart';
import 'package:grocery_app/features/home/model/category_model.dart';

class CategoryRepo {
  final CategoryService categoryService;
  CategoryRepo({required this.categoryService});
  Future<List<CategoryModel>> getCategories() async {
    return await categoryService.getCategory();
  }
}
