import 'package:glitchx_admin/features/Product_Page/Domain/Product_repository/product_repository.dart';
import 'package:glitchx_admin/features/Product_Page/Domain/models/product_model.dart';

class GetProductUsecase {
  final ProductRepository productRepository;

  GetProductUsecase({required this.productRepository});

  Future<List<ProductModel>> execute() async {
    return await productRepository.fetchProducts();
  }
}
