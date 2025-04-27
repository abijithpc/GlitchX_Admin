import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/Core/Widgets/ScreenBackground/screen_background.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/models/product_model.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/Bloc/product_bloc.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/Bloc/product_event.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/Bloc/product_state.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/add_productpage.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/edit_productpage.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchProductEvent());
  }

  Widget _buildProductImage(ProductModel product) {
    if (product.imageUrl.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Icon(Icons.image_not_supported, size: 30),
      );
    }

    if (product.imageUrl.startsWith('http')) {
      return Image.network(
        product.imageUrl,
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
        File(product.imageUrl),
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.insert_drive_file, size: 30);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: ScreenBackGround(
        screenHeight: screenHeight,
        screenWidth: screenWidth,
        widget: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Products',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Icon(CupertinoIcons.cart_fill, color: Colors.deepPurple),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state is ProductDeleted) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Product Deleted Successfully'),
                          ),
                        );
                      });
                    }
                    if (state is ProductUpdated) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Product Updated Successfully"),
                          ),
                        );
                      });
                    } else if (state is EditProductImageSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Image updated Successfully")),
                      );
                      setState(() {
                        context.read<ProductBloc>().add(FetchProductEvent());
                      });
                    } else if (state is Productloading) {
                      return const Center(
                        child: CupertinoActivityIndicator(color: Colors.white),
                      );
                    } else if (state is ProductLoaded) {
                      final productList = state.products;

                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<ProductBloc>().add(FetchProductEvent());
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: productList.length,
                          itemBuilder: (context, index) {
                            final product = productList[index];
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
                                    child: _buildProductImage(product),
                                  ),
                                ),
                                title: Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  product.category,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
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
                                      builder:
                                          (context) =>
                                              EditProductPage(product: product),
                                    ),
                                  );
                                },
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: const Text('Remove Product'),
                                        content: const Text(
                                          'Are you sure you want to remove this product?',
                                        ),
                                        actions: [
                                          CupertinoDialogAction(
                                            onPressed: () {
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
                                },
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is ProductFailure) {
                      return Center(child: Text(state.message));
                    } else {
                      return const Center(child: Text('No data Available'));
                    }
                    return SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductPage()),
          );
        },
        backgroundColor: Colors.white,
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(
          CupertinoIcons.add_circled_solid,
          color: Colors.deepPurple,
          size: 30,
        ),
      ),
    );
  }
}
