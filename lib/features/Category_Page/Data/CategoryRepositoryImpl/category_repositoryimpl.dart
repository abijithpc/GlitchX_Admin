import 'package:glitchx_admin/features/Category_Page/Data/Category_RemoteDatasource/category_remotedatasource.dart';
import 'package:glitchx_admin/features/Category_Page/Domain/Models/category_models.dart';
import 'package:glitchx_admin/features/Category_Page/Domain/category_repository/category_repository.dart';

class CategoryRepositoryimpl implements CategoryRepository {
  final CategoryRemotedatasource remotedatasource;

  CategoryRepositoryimpl(this.remotedatasource);

  @override
  Future<void> addCategory(CategoryModels category) =>
      remotedatasource.addCategory(category);

  @override
  Future<List<CategoryModels>> getCategories() =>
      remotedatasource.fetchCategories();

  @override
  Future<void> deleteCategory(String categoryId) async {
    await remotedatasource.deleteCategory(categoryId);
  }

  @override
  Future<void> updateCategory(CategoryModels category) {
    return remotedatasource.updateCategory(category);
  }
}
