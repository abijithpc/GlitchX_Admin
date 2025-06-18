import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/Core/Widgets/ScreenBackground/screen_background.dart';
import 'package:glitchx_admin/features/Category_Page/Presentation/Bloc/category_bloc.dart';
import 'package:glitchx_admin/features/Category_Page/Presentation/Bloc/category_event.dart';
import 'package:glitchx_admin/features/Category_Page/Presentation/Bloc/category_state.dart';
import 'package:glitchx_admin/features/Product_Page/Presentation/widget/add_productform.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text("Add New Game"),
        backgroundColor: CupertinoColors.black,
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (state is CategoryLoaded) {
            return ScreenBackGround(
              widget: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: AddProductForm(
                  categories: state.categories.map((e) => e.name).toList(),
                ),
              ),
              screenHeight: MediaQuery.of(context).size.height,
              screenWidth: MediaQuery.of(context).size.width,
            );
          } else if (state is CategoryError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text("No Categories Found"));
          }
        },
      ),
    );
  }
}
