import 'package:glitchx_admin/features/Category_Page/Domain/Models/category_models.dart';

abstract class CategoryEvent {}

class AddCategoryEvent extends CategoryEvent {
  final CategoryModels category;

  AddCategoryEvent(this.category);
}

class LoadCategoriesEvent extends CategoryEvent {}

class EditCategoryEvent extends CategoryEvent {
  final CategoryModels category;

  EditCategoryEvent(this.category);
}

class DeleteCategoryEvent extends CategoryEvent {
  final String categoryId;

  DeleteCategoryEvent(this.categoryId);
}

class UpdateCategoryEvent extends CategoryEvent {
  final CategoryModels category;
  UpdateCategoryEvent(this.category);
}
