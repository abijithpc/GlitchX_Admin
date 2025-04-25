import 'package:glitchx_admin/features/ProductPage/Domain/Product_repository/product_repository.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/models/product_model.dart';

class GetProductUsecase {
  final ProductRepository productRepository;

  GetProductUsecase({required this.productRepository});

  Future<List<ProductModel>> execute() async {
    return await productRepository.fetchProducts();
  }
}
