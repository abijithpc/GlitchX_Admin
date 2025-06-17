import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glitchx_admin/features/Orders_Page/Domain/Model/orderitems.dart';

class OrderRemotedatasource {
  final FirebaseFirestore _firestore;

  OrderRemotedatasource(this._firestore);

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': newStatus,
    });
  }

  Future<List<OrderModel>> fetchOrders() async {
    final snapshot =
        await _firestore
            .collection('orders')
            .orderBy('orderedAt', descending: true)
            .get();
    for (var doc in snapshot.docs) {
      print("Order Document: ${doc.data()}");
    }
    return snapshot.docs
        .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
        .toList();
  }
}
