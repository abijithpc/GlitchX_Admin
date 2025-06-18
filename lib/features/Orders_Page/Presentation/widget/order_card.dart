import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/Core/constant.dart';
import 'package:glitchx_admin/features/Orders_Page/Domain/Model/orderitems.dart';
import 'package:glitchx_admin/features/Orders_Page/Presentation/Bloc/order_bloc.dart';
import 'package:glitchx_admin/features/Orders_Page/Presentation/Bloc/order_event.dart';
import 'package:glitchx_admin/features/Orders_Page/Presentation/order_details_page.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat.yMMMd().add_jm().format(date);
}

Card OrderCard(OrderModel order, BuildContext context) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8),
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => OrderDetailsPage(order: order)),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.receipt_long, color: Colors.black87),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Order ID: ${order.id}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.currency_rupee, size: 18),
                const SizedBox(width: 4),
                Text("Total: ₹${order.total.toStringAsFixed(2)}"),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (order.status.toLowerCase() !=
                    OrderStatus.cancelled.toLowerCase())
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.update),
                    onSelected: (newStatus) {
                      context.read<OrderBloc>().add(
                        ChangeOrderStatusEvent(
                          orderId: order.id,
                          newStatus: newStatus,
                        ),
                      );
                    },
                    itemBuilder:
                        (context) => [
                          PopupMenuItem(
                            value: OrderStatus.ordered,
                            child: Text(OrderStatus.ordered),
                          ),
                          // PopupMenuItem(
                          //   value: OrderStatus.orderPlaced,
                          //   child: Text(OrderStatus.orderPlaced),
                          // ),
                          PopupMenuItem(
                            value: OrderStatus.shipped,
                            child: Text(OrderStatus.shipped),
                          ),
                          PopupMenuItem(
                            value: OrderStatus.delivered,
                            child: Text(OrderStatus.delivered),
                          ),
                          PopupMenuItem(
                            value: OrderStatus.cancelled,
                            child: Text(OrderStatus.cancelled),
                          ),
                        ],
                  ),
                Text(
                  order.status,
                  style: const TextStyle(color: Colors.blueGrey),
                ),
                Text(
                  formatDate(order.timestamp.toDate()),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
