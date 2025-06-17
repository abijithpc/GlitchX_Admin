import 'package:glitchx_admin/features/Orders_Page/Data/Order_RemoteDatasource/order_remotedatasource.dart';
import 'package:glitchx_admin/features/Orders_Page/Domain/Model/orderitems.dart';
import 'package:glitchx_admin/features/Orders_Page/Domain/order_repository/order_repository.dart';

class OrderRepositoryimpl implements OrderRepository {
  final OrderRemotedatasource _remotedatasource;

  OrderRepositoryimpl(this._remotedatasource);

  @override
  Future<List<OrderModel>> fetchOrders() {
    return _remotedatasource.fetchOrders();
  }

  @override
  Future<void> updateOrderStatus(String orderId, String newStatus) {
    return _remotedatasource.updateOrderStatus(orderId, newStatus);
  }
}
