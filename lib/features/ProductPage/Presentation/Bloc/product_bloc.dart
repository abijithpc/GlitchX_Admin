import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/UseCase/delete_usecase.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/UseCase/edit_usecase.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/UseCase/get_product_usecase.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/UseCase/uploadproduct_usecase.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/models/product_model.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/Bloc/product_event.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/Bloc/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final UploadproductUsecase productUsecase;
  final GetProductUsecase getProductUsecase;
  final DeleteProductUsecase deleteProductUsecase;
  final EditProductUsecase editProductUsecase;

  ProductBloc({
    required this.productUsecase,
    required this.getProductUsecase,
    required this.deleteProductUsecase,
    required this.editProductUsecase,
  }) : super(ProductIntial()) {
    on<UploadProductEvent>((event, emit) async {
      emit(Productloading());
      try {
        await productUsecase(event.product, event.image);
        final products = await getProductUsecase.execute();
        emit(ProductLoaded(products: products));
      } catch (e) {
        emit(ProductFailure(e.toString()));
      }
    });

    on<FetchProductEvent>((event, emit) async {
      emit(Productloading());
      try {
        final products = await getProductUsecase.execute();
        emit(ProductLoaded(products: products));
      } catch (e) {
        emit(ProductFailure('Failed to Fetch Product: $e'));
        print("Error Fetching products : $e");
      }
    });

    on<DeleteProductEvent>((event, emit) async {
      emit(Productloading());
      try {
        await deleteProductUsecase(event.productId);
        final products = await getProductUsecase.execute();
        emit(ProductLoaded(products: products));
      } catch (e) {
        emit(ProductFailure('Failed to Delete product : ${e.toString()}'));
        print("Error deleting product: $e");
      }
    });

    on<EditProductEvent>((event, emit) async {
      emit(Productloading());
      try {
        final success = await editProductUsecase.execute(event.updatedProduct);
        if (success) {
          final products = await getProductUsecase.execute();
          emit(ProductLoaded(products: products));
        }
      } catch (e) {
        emit(ProductFailure(e.toString()));
      }
    });
  }
}
