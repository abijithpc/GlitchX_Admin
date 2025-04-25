import 'dart:io';

import 'package:glitchx_admin/features/ProductPage/Domain/models/product_model.dart';

abstract class ProductRepository {
  Future<void> uploadProduct(ProductModel product, File image);

  Future<List<ProductModel>> fetchProducts();
}
