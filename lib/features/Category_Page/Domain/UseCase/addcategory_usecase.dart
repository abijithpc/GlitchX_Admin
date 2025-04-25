import 'package:glitchx_admin/features/Category_Page/Domain/Models/category_models.dart';
import 'package:glitchx_admin/features/Category_Page/Domain/category_repository/category_repository.dart';

class AddcategoryUsecase {
  final CategoryRepository repository;

  AddcategoryUsecase(this.repository);

  Future<void> call(CategoryModels category) =>
      repository.addCategory(category);
}
