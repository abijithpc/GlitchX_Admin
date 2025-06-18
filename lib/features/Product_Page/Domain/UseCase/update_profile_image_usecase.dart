import 'dart:io';
import 'package:glitchx_admin/features/Product_Page/Domain/Product_repository/product_repository.dart';

class EditProductImageUseCase {
  final ProductRepository repository;

  EditProductImageUseCase(this.repository);

  Future<String?> execute(File imageFile, String productId) async {
    try {
      // Upload the image and get the image URL
      final imageUrl = await repository.editProductImage(imageFile, productId);

      // Check if the URL is valid
      if (imageUrl == null ||
          imageUrl.isEmpty ||
          !imageUrl.startsWith('http')) {
        throw Exception("Invalid image URL received");
      }

      return imageUrl;
    } catch (e) {
      // Handle any exceptions that occur during the image edit process
      throw Exception('Error editing product image: $e');
    }
  }
}
