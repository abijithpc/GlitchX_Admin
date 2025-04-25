import 'package:glitchx_admin/features/Category_Page/Domain/Models/category_models.dart';

abstract class CategoryEvent {}

class AddCategoryEvent extends CategoryEvent {
  final CategoryModels category;

  AddCategoryEvent(this.category);
}

class LoadCategoriesEvent extends CategoryEvent {}
