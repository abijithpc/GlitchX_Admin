import 'dart:io';

import 'package:glitchx_admin/features/ProductPage/Data/Product_RemoteDatasource/product_data_remotesource.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/Product_repository/product_repository.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/models/product_model.dart';

class ProductRepositoryimpl implements ProductRepository {
  final ProductDataRemotesource productDataRemotesource;

  ProductRepositoryimpl({required this.productDataRemotesource});

  @override
  Future<void> uploadProduct(ProductModel product, File image) async {
    final imageUrl = await productDataRemotesource.uploadImageTOCloudinary(
      image,
    );
    final updatedProduct = ProductModel(
      name: product.name,
      category: product.category,
      description: product.description,
      imageUrl: imageUrl,
      price: product.price,
      stock: product.stock,
      diskcount: product.diskcount,
      minSpecs: product.minSpecs,
      recSpecs: product.recSpecs,
      releaseDate: product.releaseDate,
    );
    await productDataRemotesource.uploadProduct(updatedProduct);
  }
}
