import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glitchx_admin/features/Orders_Page/Domain/Model/address_model.dart';

class OrderItem {
  final String productId;
  final String name;
  final int quantity;
  final double price;
  final String imageUrl;

  OrderItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    int parseQuantity(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    double parsePrice(dynamic value) {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return OrderItem(
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      quantity: parseQuantity(map['quantity']),
      price: parsePrice(map['price']),
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}

class OrderModel {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double total;
  final AddressModel address;
  final String status;
  final Timestamp timestamp;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.timestamp,
    required this.address,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      userId: map['userId'] ?? '',
      items:
          (map['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromMap(e))
              .toList() ??
          [], // ✅ parse items
      total: (map['totalAmount'] ?? 0).toDouble(),
      status: map['status'] ?? 'Pending',

      address: AddressModel.fromMap(map['address'] ?? {}),
      timestamp:
          map['orderedAt'] is Timestamp
              ? map['orderedAt']
              : Timestamp.fromDate(DateTime.parse(map['orderedAt'])),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'status': status,
      'timestamp': timestamp,
      // 'address': address,
    };
  }
}
