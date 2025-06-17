import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> migrateOrderedAtToTimestamp() async {
  final firestore = FirebaseFirestore.instance;
  final snapshot = await firestore.collection('orders').get();

  for (final doc in snapshot.docs) {
    final data = doc.data();
    final orderedAt = data['orderedAt'];

    if (orderedAt is String) {
      final parsedDate = DateTime.tryParse(orderedAt);
      if (parsedDate != null) {
        await doc.reference.update({
          'orderedAt': Timestamp.fromDate(parsedDate),
        });
        print("✅ Migrated order ${doc.id}");
      } else {
        print("❌ Could not parse date for ${doc.id}: $orderedAt");
      }
    } else {
      print("✅ Already Timestamp for ${doc.id}");
    }
  }
}
