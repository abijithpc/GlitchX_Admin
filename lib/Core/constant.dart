import 'package:flutter/material.dart';

final cloudinarylink =
    'https://api.cloudinary.com/v1_1/glitchx_upload/image/upload';

class OrderStatus {
  static const ordered = "Ordered";
  static const orderPlaced = "Order Placed";
  static const shipped = "Shipped";
  static const delivered = "Delivered";
  static const cancelled = "Cancelled";
  // add more as needed
}

Color getStatusColor(String status) {
  switch (status) {
    case OrderStatus.orderPlaced:
      return Colors.orange;
    case OrderStatus.shipped:
      return Colors.blue;
    case OrderStatus.delivered:
      return Colors.green;
    case OrderStatus.cancelled:
      return Colors.red;
    default:
      return Colors.grey;
  }
}
