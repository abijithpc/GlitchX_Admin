import 'package:glitchx_admin/features/Product_Page/Domain/Product_repository/product_repository.dart';
import 'package:glitchx_admin/features/Product_Page/Domain/models/product_model.dart';

class EditProductUsecase {
  final ProductRepository repository;

  EditProductUsecase(this.repository);

  Future<bool> execute(ProductModel updatedproduct) async {
    try {
      final success = await repository.updateProduct(updatedproduct);
      return success;
    } catch (e) {
      throw Exception("Failed to Update product: $e");
    }
  }
}
