import 'dart:io';

import 'package:glitchx_admin/features/Product_Page/Domain/models/product_model.dart';

abstract class ProductRepository {
  Future<void> uploadProduct(ProductModel product, List<File> image);

  Future<List<ProductModel>> fetchProducts();

  // Future<void> editProduct(ProductModel product);

  Future<void> deleteProduct(String productId);

  Future<bool> updateProduct(ProductModel product);

  Future<String?> editProductImage(File imageFile, String productId);
}
