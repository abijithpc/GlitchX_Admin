import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/models/product_model.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/Bloc/product_bloc.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/Bloc/product_event.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/screens/edit_productpage.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/widget/product_image.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;

  const ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: SizedBox(
          width: 60,
          height: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ProductImage(product: product),
          ),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          product.category,
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        trailing: Text(
          "₹ ${product.price}",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.deepPurple,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProductPage(product: product),
            ),
          );
        },
        onLongPress: () {
          _showDeleteDialog(context);
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Remove Product'),
          content: const Text('Are you sure you want to remove this product?'),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                // Call delete action
                context.read<ProductBloc>().add(
                  DeleteProductEvent(product.id!),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
