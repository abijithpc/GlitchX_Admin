import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glitchx_admin/features/Home_Page/Domain/Model/revenue_model.dart';

class RevenueRemoteDataSource {
  final FirebaseFirestore firestore;

  RevenueRemoteDataSource(this.firestore);

  Future<List<RevenueModel>> fetchPaidOrders() async {
    final snapshot =
        await firestore
            .collection('orders')
            .where('status', isEqualTo: 'Delivered')
            .get();
    for (var doc in snapshot.docs) {
      print("Order ID: ${doc.id} | Data: ${doc.data()}");
    }
    print("Fetched documents: ${snapshot.docs.length}");
    print("Data: ${snapshot.docs.map((doc) => doc.data())}");

    return snapshot.docs
        .map((doc) => RevenueModel.fromMap(doc.data()))
        .toList();
  }

  Future<int> getOrderCount() async {
    final snapshot = await firestore.collection('orders').get();
    return snapshot.docs.length;
  }

  Future<int> getTotalQuantitySold() async {
    final snapshot =
        await firestore
            .collection('orders')
            .where(
              'status',
              isEqualTo: 'Delivered',
            ) // only include delivered orders
            .get();

    int totalQuantity = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final items = data['items'] as List<dynamic>? ?? [];

      for (var item in items) {
        final quantity = item['quantity'];
        if (quantity is int) {
          totalQuantity += quantity;
        } else if (quantity is String) {
          final parsed = int.tryParse(quantity);
          totalQuantity += parsed ?? 0;
        }
      }
    }

    return totalQuantity;
  }

  Future<List<RevenueModel>> getOrdersInRange(
    DateTime from,
    DateTime to,
  ) async {
    final start = DateTime(from.year, from.month, from.day).toUtc();
    final end = DateTime(to.year, to.month, to.day, 23, 59, 59, 999).toUtc();

    final snapshot =
        await firestore
            .collection('orders')
            .where('status', isEqualTo: 'Delivered')
            .where(
              'orderedAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(start),
            )
            .where('orderedAt', isLessThanOrEqualTo: Timestamp.fromDate(end))
            .get();

    return snapshot.docs
        .map((doc) => RevenueModel.fromMap(doc.data()))
        .toList();
  }

  Future<int> getTotalQuantityInRange(DateTime from, DateTime to) async {
    final snapshot =
        await firestore
            .collection('orders')
            .where('status', isEqualTo: 'Delivered')
            .where(
              'orderedAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(from.toUtc()),
            )
            .where(
              'orderedAt',
              isLessThanOrEqualTo: Timestamp.fromDate(to.toUtc()),
            )
            .get();
    print("Fetched Orders:");
    for (final doc in snapshot.docs) {
      print(doc['orderedAt']); // Should print Timestamp
    }

    int total = 0;
    for (var doc in snapshot.docs) {
      final items = doc['items'] ?? [];
      for (var item in items) {
        final qty = item['quantity'];
        total += qty is int ? qty : int.tryParse(qty.toString()) ?? 0;
      }
    }
    return total;
  }
}
