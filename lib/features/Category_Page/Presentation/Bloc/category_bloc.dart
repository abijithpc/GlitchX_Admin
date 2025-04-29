import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/features/Category_Page/Domain/UseCase/addcategory_usecase.dart';
import 'package:glitchx_admin/features/Category_Page/Domain/UseCase/delete_category_usecase.dart';
import 'package:glitchx_admin/features/Category_Page/Domain/UseCase/edit_category_usecase.dart';
import 'package:glitchx_admin/features/Category_Page/Domain/UseCase/get_category_usecase.dart';
import 'package:glitchx_admin/features/Category_Page/Presentation/Bloc/category_event.dart';
import 'package:glitchx_admin/features/Category_Page/Presentation/Bloc/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final AddcategoryUsecase addCategory;
  final GetCategoryUsecase getCategory;
  final DeleteCategoryUsecase deleteCategory;
  final UpdateCategoryUsecase updateCategory;

  CategoryBloc({
    required this.addCategory,
    required this.getCategory,
    required this.deleteCategory,
    required this.updateCategory,
  }) : super(CategoryIntial()) {
    on<AddCategoryEvent>(_onAddCategory);
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<DeleteCategoryEvent>(_deleteCategory);
    on<UpdateCategoryEvent>(_updateCategory);
  }

  Future<void> _onAddCategory(
    AddCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      await addCategory(event.category);
      add(LoadCategoriesEvent());
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      final categories = await getCategory();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _deleteCategory(
    DeleteCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      await deleteCategory(event.categoryId);
      emit(CategoryDeleted());
      add(LoadCategoriesEvent());
    } catch (e) {
      emit(CategoryError("Failed to delete category: $e"));
    }
  }

  Future<void> _updateCategory(
    UpdateCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      await updateCategory.call(event.category);
      emit(CategoryUpdated());
      add(LoadCategoriesEvent());
    } catch (e) {
      emit(CategoryError("Failed to edit Category : $e"));
    }
  }
}
