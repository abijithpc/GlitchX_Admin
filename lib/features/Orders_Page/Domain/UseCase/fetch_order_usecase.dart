import 'package:glitchx_admin/features/Orders_Page/Domain/Model/orderitems.dart';
import 'package:glitchx_admin/features/Orders_Page/Domain/order_repository/order_repository.dart';

class FetchOrdersUseCase {
  final OrderRepository repository;

  FetchOrdersUseCase(this.repository);

  Future<List<OrderModel>> call() {
    return repository.fetchOrders();
  }
}
