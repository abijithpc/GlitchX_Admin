import 'package:glitchx_admin/features/Category_Page/Domain/Models/category_models.dart';

abstract class CategoryState {}

class CategoryIntial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryModels> categories;
  CategoryLoaded(this.categories);
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);
}
