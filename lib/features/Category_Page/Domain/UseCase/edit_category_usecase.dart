import 'package:glitchx_admin/features/Category_Page/Domain/Models/category_models.dart';
import 'package:glitchx_admin/features/Category_Page/Domain/category_repository/category_repository.dart';

class UpdateCategoryUsecase {
  final CategoryRepository categoryRepository;

  UpdateCategoryUsecase({required this.categoryRepository});

  Future<void> call(CategoryModels category) async {
    await categoryRepository.updateCategory(category);
  }
}
