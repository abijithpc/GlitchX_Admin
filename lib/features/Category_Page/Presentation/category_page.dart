import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/Core/Widgets/ScreenBackground/screen_background.dart';
import 'package:glitchx_admin/features/Category_Page/Presentation/Bloc/category_bloc.dart';
import 'package:glitchx_admin/features/Category_Page/Presentation/Bloc/category_event.dart';
import 'package:glitchx_admin/features/Category_Page/Presentation/Bloc/category_state.dart';
import 'package:glitchx_admin/features/Category_Page/Presentation/widget/delete_edit.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return CupertinoPageScaffold(
      backgroundColor: Colors.black,
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          'Brands',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: CupertinoColors.systemGroupedBackground.withOpacity(
          0.95,
        ),
        border: null,
      ),
      child: SafeArea(
        child: ScreenBackGround(
          widget: Column(
            children: [
              Expanded(
                child: BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoading) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else if (state is CategoryLoaded) {
                      if (state.categories.isEmpty) {
                        return const Center(child: Text("No Brand available"));
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.categories.length,
                        itemBuilder: (context, index) {
                          final category = state.categories[index];
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: CupertinoColors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12.withOpacity(0.05),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text(
                                category.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: CupertinoColors.label,
                                ),
                              ),
                              trailing: const Icon(
                                CupertinoIcons.chevron_forward,
                                size: 20,
                                color: CupertinoColors.systemGrey,
                              ),
                              onTap: () {
                                showEditCategorySheet(context, category);
                              },
                              onLongPress: () {
                                showDeleteCategoryDialog(context, category.id);
                              },
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                      );
                    } else if (state is CategoryError) {
                      return Center(child: Text("Error: ${state.message}"));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: CupertinoButton.filled(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  borderRadius: BorderRadius.circular(14),
                  onPressed: () => showAddCategorySheet(context),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.add_circled_solid, size: 22),
                      SizedBox(width: 8),
                      Text("Add Category"),
                    ],
                  ),
                ),
              ),
            ],
          ),
          screenHeight: screenHeight,
          screenWidth: screenWidth,
        ),
      ),
    );
  }
}
