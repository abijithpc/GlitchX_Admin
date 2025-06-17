import 'package:glitchx_admin/features/Orders_Page/Domain/Model/orderitems.dart';

abstract class OrderRepository {
  Future<List<OrderModel>> fetchOrders();
  Future<void> updateOrderStatus(String orderId, String newStatus);
}
