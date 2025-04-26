import 'package:glitchx_admin/features/ProductPage/Domain/Product_repository/product_repository.dart';

class DeleteProductUsecase {
  final ProductRepository repository;

  DeleteProductUsecase(this.repository);

  Future<void> call(String productId) async {
    return await repository.deleteProduct(productId);
  }
}
