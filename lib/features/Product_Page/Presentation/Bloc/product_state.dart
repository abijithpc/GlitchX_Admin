import 'package:equatable/equatable.dart';
import 'package:glitchx_admin/features/Product_Page/Domain/models/product_model.dart';

abstract class ProductState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductIntial extends ProductState {}

class Productloading extends ProductState {}

class ProductSuccess extends ProductState {}

class ProductFailure extends ProductState {
  final String message;
  ProductFailure(this.message);
}

class ProductLoaded extends ProductState {
  final List<ProductModel> products;

  @override
  ProductLoaded({required this.products});
  @override
  List<Object> get props => [products];
}

class ProductUpdated extends ProductState {}

class ProductDeleted extends ProductState {}

class ProductImageUpdated extends ProductState {
  final String imageUrl;

  ProductImageUpdated({required this.imageUrl});
}

class EditProductImageInitial extends ProductState {}

class EditProductImageLoading extends ProductState {}

class EditProductImageSuccess extends ProductState {
  final String imageUrl;

  EditProductImageSuccess(this.imageUrl);
}

class EditProductImageError extends ProductState {
  final String message;

  EditProductImageError(this.message);
}
