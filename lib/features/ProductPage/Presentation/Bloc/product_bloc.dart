import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/UseCase/get_product_usecase.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/UseCase/uploadproduct_usecase.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/Bloc/product_event.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/Bloc/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final UploadproductUsecase productUsecase;
  final GetProductUsecase getProductUsecase;

  ProductBloc({required this.productUsecase, required this.getProductUsecase})
    : super(ProductIntial()) {
    on<UploadProductEvent>((event, emit) async {
      emit(Productloading());
      try {
        await productUsecase(event.product, event.image);
        emit(ProductSuccess());
      } catch (e) {
        emit(ProductFailure(e.toString()));
      }
    });

    on<FetchProductEvent>((event, emit) async {
      emit(Productloading());
      try {
        final products = await getProductUsecase.execute();
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductFailure('Failed to Fetch Product: $e'));
        print("Error Fetching products : $e");
      }
    });
  }
}
