import 'package:glitchx_admin/features/Category_Page/Domain/Models/category_models.dart';

abstract class CategoryRepository {
  Future<void> addCategory(CategoryModels category);
  Future<List<CategoryModels>> getCategories();
}
