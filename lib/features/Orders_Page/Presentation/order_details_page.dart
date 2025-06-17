import 'package:flutter/material.dart';
import 'package:glitchx_admin/Core/Widgets/ScreenBackground/screen_background.dart';
import 'package:glitchx_admin/features/Orders_Page/Presentation/widget/address_section.dart';
import 'package:intl/intl.dart';
import 'package:glitchx_admin/features/Orders_Page/Domain/Model/orderitems.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsPage({Key? key, required this.order}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: ScreenBackGround(
        screenHeight: screenHeight,
        screenWidth: screenWidth,
        widget: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              sectionCard(
                title: "Order Info",
                icon: Icons.info,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    infoRow(Icons.receipt_long, "Order ID", order.id),
                    infoRow(
                      Icons.attach_money,
                      "Total",
                      "₹${order.total.toStringAsFixed(2)}",
                    ),
                    infoRow(
                      Icons.schedule,
                      "Placed on",
                      formatDate(order.timestamp.toDate()),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.local_shipping,
                          color: Colors.deepPurple,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Status: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Chip(
                          label: Text(order.status),
                          backgroundColor: getStatusColor(
                            order.status,
                          ).withAlpha(100),
                          labelStyle: TextStyle(
                            color: getStatusColor(order.status),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              sectionCard(
                title: "Shipping Address",
                icon: Icons.location_on,
                child: addressSection(order.address),
              ),

              const SizedBox(height: 16),

              sectionCard(
                title: "Ordered Items",
                icon: Icons.shopping_bag,
                child: Column(
                  children:
                      order.items
                          .map(
                            (item) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.imageUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text("Qty: ${item.quantity}"),
                                trailing: Text(
                                  "₹${item.price.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => generateAndPrintInvoice(context, order),
        label: const Text(
          'Download Invoice',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(Icons.download, color: Colors.white),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
