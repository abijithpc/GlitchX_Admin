import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/UseCase/uploadproduct_usecase.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/Bloc/product_event.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/Bloc/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final UploadproductUsecase productUsecase;

  ProductBloc(this.productUsecase) : super(ProductIntial()) {
    on<UploadProductEvent>((event, emit) async {
      emit(ProductUploading());
      try {
        await productUsecase(event.product, event.image);
        emit(ProductSuccess());
      } catch (e) {
        emit(ProductFailure(e.toString()));
      }
    });
  }
}
