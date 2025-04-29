import 'package:glitchx_admin/features/Category_Page/Domain/category_repository/category_repository.dart';

class DeleteCategoryUsecase {
  final CategoryRepository repository;

  DeleteCategoryUsecase({required this.repository});

  Future<void> call(String categoryId) async {
    await repository.deleteCategory(categoryId);
  }
}
