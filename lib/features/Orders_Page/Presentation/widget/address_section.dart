import 'package:flutter/material.dart';
import 'package:glitchx_admin/features/Orders_Page/Domain/Model/address_model.dart';
import 'package:glitchx_admin/features/Orders_Page/Domain/Model/orderitems.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Widget addressSection(AddressModel address) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Shipping Address",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      Text("Name: ${address.name}"),
      Text("Phone: ${address.phone}"),
      Text("House: ${address.house}"),
      Text("Area: ${address.area}"),
      Text("City: ${address.city}"),
      Text("State: ${address.state}"),
      Text("Pincode: ${address.pincode}"),
    ],
  );
}

Widget infoRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 20),
        const SizedBox(width: 8),
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
      ],
    ),
  );
}

Widget sectionCard({
  required String title,
  required IconData icon,
  required Widget child,
}) {
  return Card(
    elevation: 4,
    margin: const EdgeInsets.only(bottom: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.deepPurple),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 1),
          child,
        ],
      ),
    ),
  );
}

String formatDate(DateTime date) {
  return DateFormat.yMMMd().add_jm().format(date);
}

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'delivered':
      return Colors.green;
    case 'pending':
      return Colors.orange;
    case 'cancelled':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

void generateAndPrintInvoice(BuildContext context, OrderModel order) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build:
          (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "GlitchX",
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text("Order ID: ${order.id}"),
              pw.Text("Date: ${formatDate(order.timestamp.toDate())}"),
              pw.Text("Status: ${order.status}"),
              pw.SizedBox(height: 10),
              pw.Text("Customer: ${order.address.name}"),
              pw.Text("Phone: ${order.address.phone}"),
              pw.Text(
                "Address: ${order.address.house}, ${order.address.area},",
              ),
              pw.Text(
                "${order.address.city} - ${order.address.pincode}, ${order.address.state}",
              ),

              pw.SizedBox(height: 20),
              pw.Text(
                "Items:",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                headers: ['Product', 'Qty', 'Price', 'Total'],
                data:
                    order.items.map((item) {
                      return [
                        item.name,
                        item.quantity.toString(),
                        "₹${item.price.toStringAsFixed(2)}",
                        "₹${(item.price * item.quantity).toStringAsFixed(2)}",
                      ];
                    }).toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Total: ₹${order.total.toStringAsFixed(2)}",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    ),
  );

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}
