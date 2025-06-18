import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/Core/Widgets/ScreenBackground/screen_background.dart';
import 'package:glitchx_admin/features/Product_Page/Presentation/Bloc/product_bloc.dart';
import 'package:glitchx_admin/features/Product_Page/Presentation/Bloc/product_event.dart';
import 'package:glitchx_admin/features/Product_Page/Presentation/Bloc/product_state.dart';
import 'package:glitchx_admin/features/Product_Page/Presentation/screens/add_productpage.dart';
import 'package:glitchx_admin/features/Product_Page/Presentation/widget/product_item.dart';

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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Products',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
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
                  children: [],
                ),
              ),
              Expanded(
                child: BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state is Productloading) {
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
                            return ProductItem(product: productList[index]);
                          },
                        ),
                      );
                    } else if (state is ProductFailure) {
                      return Center(child: Text(state.message));
                    } else {
                      return const Center(child: Text('No data Available'));
                    }
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
