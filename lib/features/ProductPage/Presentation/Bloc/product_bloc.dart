import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/UseCase/delete_usecase.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/UseCase/edit_usecase.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/UseCase/get_product_usecase.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/UseCase/update_profile_image_usecase.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/UseCase/uploadproduct_usecase.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/Bloc/product_event.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/Bloc/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final UploadproductUsecase productUsecase;
  final GetProductUsecase getProductUsecase;
  final DeleteProductUsecase deleteProductUsecase;
  final EditProductUsecase editProductUsecase;
  final EditProductImageUseCase updateProductImageUsecase;

  ProductBloc({
    required this.productUsecase,
    required this.getProductUsecase,
    required this.deleteProductUsecase,
    required this.editProductUsecase,
    required this.updateProductImageUsecase,
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

    on<EditProductImageSubmitted>((event, emit) async {
      emit(Productloading());
      try {
        final imageUrl = await updateProductImageUsecase.execute(
          event.imageFile,
          event.productId,
        );
        if (imageUrl != null) {
          // After updating the image, fetch the product list and emit the new state
          final products = await getProductUsecase.execute();

          // Log the updated products to inspect their state
          print(
            'Fetched Products: $products',
          ); // This will now print the product details properly

          final updatedProducts =
              products.map((product) {
                if (product.id == event.productId) {
                  return product.copyWith(
                    imageUrl: imageUrl,
                  ); // Update the image URL
                }
                return product;
              }).toList();

          emit(ProductLoaded(products: updatedProducts));
        } else {
          emit(ProductFailure('Failed to update image'));
        }
      } catch (e) {
        emit(ProductFailure('Failed to update image: $e'));
        print("Error updating image: $e");
      }
    });
  }
}
