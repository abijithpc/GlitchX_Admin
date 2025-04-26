import 'dart:io';

import 'package:glitchx_admin/features/ProductPage/Domain/models/product_model.dart';

abstract class ProductEvent {}

class UploadProductEvent extends ProductEvent {
  final ProductModel product;
  final File image;

  UploadProductEvent({required this.product, required this.image});
}

class FetchProductEvent extends ProductEvent {}

class DeleteProductEvent extends ProductEvent {
  final String productId;

  DeleteProductEvent(this.productId);
}

class EditProductEvent extends ProductEvent {
  final ProductModel updatedProduct;

  EditProductEvent(this.updatedProduct);
}
