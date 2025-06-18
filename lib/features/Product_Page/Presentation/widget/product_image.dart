import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glitchx_admin/features/Product_Page/Domain/models/product_model.dart';

class ProductImage extends StatelessWidget {
  final ProductModel product;

  const ProductImage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (product.imageUrls.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Icon(Icons.image_not_supported, size: 30),
      );
    }

    return ListView.builder(
      itemCount: product.imageUrls.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final imageUrl = product.imageUrls[index];

        if (imageUrl.startsWith('http')) {
          return Image.network(
            imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CupertinoActivityIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.broken_image, size: 30);
            },
          );
        } else {
          return Image.file(
            File(imageUrl),
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.insert_drive_file, size: 30);
            },
          );
        }
      },
    );
  }
}
