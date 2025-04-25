abstract class ProductState {}

class ProductIntial extends ProductState {}

class ProductUploading extends ProductState {}

class ProductSuccess extends ProductState {}

class ProductFailure extends ProductState {
  final String message;
  ProductFailure(this.message);
}
