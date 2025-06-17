import 'package:cloud_firestore/cloud_firestore.dart';

class RevenueModel {
  final double price;
  final DateTime orderedAt;
  final int quantity;
  final String status;

  RevenueModel({
    required this.price,
    required this.orderedAt,
    required this.quantity,
    required this.status,
  });

  factory RevenueModel.fromMap(Map<String, dynamic> map) {
    try {
      // Extract and calculate total quantity from order items
      int totalQuantity = 0;
      if (map['items'] != null && map['items'] is List) {
        totalQuantity = (map['items'] as List).fold(0, (sum, item) {
          final dynamic quantity = item['quantity'];
          if (quantity is int) return sum + quantity;
          if (quantity is String) {
            final parsed = int.tryParse(quantity);
            return sum + (parsed ?? 0);
          }
          return sum;
        });
      }

      // Parse totalAmount field safely
      double price = 0.0;
      final dynamic priceField = map['totalAmount'];
      if (priceField is int) {
        price = priceField.toDouble();
      } else if (priceField is double) {
        price = priceField;
      } else if (priceField is String) {
        price = double.tryParse(priceField) ?? 0.0;
      }

      // Parse date
      DateTime orderedAt = DateTime.now();
      final dynamic dateField = map['orderedAt'];
      if (dateField is String) {
        orderedAt = DateTime.tryParse(dateField) ?? orderedAt;
      } else if (dateField is Timestamp) {
        orderedAt = dateField.toDate();
      }

      return RevenueModel(
        price: price,
        orderedAt: orderedAt,
        quantity: totalQuantity,
        status: map['status'] ?? '',
      );
    } catch (e) {
      print('Error parsing RevenueModel: $e \nData: $map');
      return RevenueModel(
        price: 0,
        orderedAt: DateTime.now(),
        quantity: 0,
        status: 'unknown',
      );
    }
  }
}
