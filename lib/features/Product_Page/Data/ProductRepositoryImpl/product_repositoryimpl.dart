import 'dart:io';

import 'package:glitchx_admin/features/Product_Page/Data/Product_RemoteDatasource/product_data_remotesource.dart';
import 'package:glitchx_admin/features/Product_Page/Domain/Product_repository/product_repository.dart';
import 'package:glitchx_admin/features/Product_Page/Domain/models/product_model.dart';

class ProductRepositoryimpl implements ProductRepository {
  final ProductDataRemotesource productDataRemotesource;

  ProductRepositoryimpl({required this.productDataRemotesource});

  @override
  Future<void> uploadProduct(ProductModel product, List<File> image) async {
    try {
      // Assuming `uploadImages` returns a List<String> of URLs
      final imageUrls = await productDataRemotesource.uploadImages(image);

      final updatedProduct = ProductModel(
        name: product.name,
        category: product.category,
        description: product.description,
        imageUrls: imageUrls.isNotEmpty ? imageUrls : [],
        price: product.price,
        stock: product.stock,
        diskCount: product.diskCount,
        minSpecs: product.minSpecs,
        recSpecs: product.recSpecs,
        releaseDate: product.releaseDate,
      );

      await productDataRemotesource.addProduct(updatedProduct);
    } catch (e) {
      throw Exception('Error uploading product: $e');
    }
  }

  @override
  Future<List<ProductModel>> fetchProducts() async {
    return await productDataRemotesource.getProducts();
  }

  // @override
  // Future<void> editProduct(ProductModel product) async {
  //   try {
  //     String imageUrl = product.imageUrl;

  //     final updatedProduct = ProductModel(
  //       name: product.name,
  //       description: product.description,
  //       category: product.category,
  //       diskCount: product.diskCount,
  //       price: product.price,
  //       stock: product.stock,
  //       minSpecs: product.minSpecs,
  //       recSpecs: product.recSpecs,
  //       releaseDate: product.releaseDate,
  //       imageUrl: imageUrl,
  //     );

  //     await productDataRemotesource.updatedProduct(updatedProduct);
  //   } catch (e) {
  //     throw Exception('Error updating Product : $e');
  //   }
  // }

  @override
  Future<void> deleteProduct(String productId) async {
    try {
      await productDataRemotesource.deleteProduct(productId);
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }

  @override
  Future<bool> updateProduct(ProductModel product) async {
    try {
      await productDataRemotesource.updateProduct(product);
      return true;
    } catch (e) {
      throw Exception('Error updating Product: $e');
    }
  }

  @override
  @override
  Future<String?> editProductImage(File imageFile, String productId) async {
    try {
      final imageUrls = await productDataRemotesource.uploadImages([imageFile]);

      if (imageUrls != null && imageUrls.isNotEmpty) {
        final imageUrl = imageUrls.first;

        print("Image URL from Cloudinary: $imageUrl");

        try {
          await productDataRemotesource.updateProductImagesInFirestore(
            productId,
            [imageUrl],
          );
        } catch (e) {
          print("Error updating product image in Firestore: $e");
          throw Exception('Error updating product image in Firestore: $e');
        }

        return imageUrl;
      } else {
        print("Failed to upload image to Cloudinary");
        throw Exception("Image URL is null or empty, upload failed.");
      }
    } catch (e) {
      print("Error in editProductImage: $e");
      throw Exception('Error editing product image: $e');
    }
  }
}
