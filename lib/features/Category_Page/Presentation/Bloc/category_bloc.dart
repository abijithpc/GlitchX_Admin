import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/features/Category_Page/Domain/UseCase/addcategory_usecase.dart';
import 'package:glitchx_admin/features/Category_Page/Domain/UseCase/get_category_usecase.dart';
import 'package:glitchx_admin/features/Category_Page/Presentation/Bloc/category_event.dart';
import 'package:glitchx_admin/features/Category_Page/Presentation/Bloc/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final AddcategoryUsecase addCategory;
  final GetCategoryUsecase getCategory;

  CategoryBloc({required this.addCategory, required this.getCategory})
    : super(CategoryIntial()) {
    on<AddCategoryEvent>(_onAddCategory);
    on<LoadCategoriesEvent>(_onLoadCategories);
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
}
