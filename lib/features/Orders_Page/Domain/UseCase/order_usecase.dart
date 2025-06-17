import 'package:glitchx_admin/features/Orders_Page/Domain/order_repository/order_repository.dart';

class UpdateOrderStatusUsecase {
  final OrderRepository _orderRepository;

  UpdateOrderStatusUsecase(this._orderRepository);

  Future<void> call(String orderId, String newStatus) {
    return _orderRepository.updateOrderStatus(orderId, newStatus);
  }
}
