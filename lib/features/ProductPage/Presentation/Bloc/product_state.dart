import 'package:equatable/equatable.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/models/product_model.dart';

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

  ProductLoaded(this.products);

  @override
  List<Object> get props => [products];
}
