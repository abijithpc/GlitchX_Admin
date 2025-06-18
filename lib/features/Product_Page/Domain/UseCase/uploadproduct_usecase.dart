import 'dart:io';

import 'package:glitchx_admin/features/Product_Page/Domain/Product_repository/product_repository.dart';
import 'package:glitchx_admin/features/Product_Page/Domain/models/product_model.dart';

class UploadproductUsecase {
  final ProductRepository repository;

  UploadproductUsecase({required this.repository});

  Future<void> call(ProductModel product, List<File> image) {
    return repository.uploadProduct(product, image);
  }
}
