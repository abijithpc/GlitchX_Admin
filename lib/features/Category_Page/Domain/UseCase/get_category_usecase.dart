import 'package:glitchx_admin/features/Category_Page/Domain/Models/category_models.dart';
import 'package:glitchx_admin/features/Category_Page/Domain/category_repository/category_repository.dart';

class GetCategoryUsecase {
  final CategoryRepository repository;

  GetCategoryUsecase(this.repository);

  Future<List<CategoryModels>> call() => repository.getCategories();
}
