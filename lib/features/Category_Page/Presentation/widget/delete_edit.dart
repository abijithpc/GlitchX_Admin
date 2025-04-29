import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/features/Category_Page/Domain/Models/category_models.dart';
import 'package:glitchx_admin/features/Category_Page/Presentation/Bloc/category_bloc.dart';
import 'package:glitchx_admin/features/Category_Page/Presentation/Bloc/category_event.dart';
import 'package:uuid/uuid.dart';

void showEditCategorySheet(BuildContext context, CategoryModels category) {
  final TextEditingController controller = TextEditingController(
    text: category.name,
  );

  showCupertinoModalPopup(
    context: context,
    builder:
        (_) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: CupertinoPopupSurface(
            isSurfacePainted: true,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGroupedBackground,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Edit Category",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CupertinoTextField(
                      controller: controller,
                      placeholder: "Enter Category name",
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    CupertinoButton.filled(
                      onPressed: () {
                        final name = controller.text.trim();
                        if (name.isNotEmpty) {
                          final updatedCategory = CategoryModels(
                            id: category.id,
                            name: name,
                          );
                          context.read<CategoryBloc>().add(
                            UpdateCategoryEvent(updatedCategory),
                          );
                          Navigator.pop(context);
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 60,
                      ),
                      child: const Text(
                        "Update",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
  );
}

void showDeleteCategoryDialog(BuildContext context, String categoryId) {
  showCupertinoDialog(
    context: context,
    builder:
        (_) => CupertinoAlertDialog(
          title: const Text("Are you sure?"),
          content: const Text("This action cannot be undone."),
          actions: [
            CupertinoDialogAction(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              child: const Text("Delete"),
              onPressed: () {
                BlocProvider.of<CategoryBloc>(
                  context,
                ).add(DeleteCategoryEvent(categoryId));
                Navigator.pop(context);
              },
            ),
          ],
        ),
  );
}

void showAddCategorySheet(BuildContext context) {
  final TextEditingController controller = TextEditingController();
  final uuid = const Uuid();

  showCupertinoModalPopup(
    context: context,
    builder:
        (_) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: CupertinoPopupSurface(
            isSurfacePainted: true,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGroupedBackground,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Add New Category",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CupertinoTextField(
                      controller: controller,
                      placeholder: "Enter Brand name",
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    CupertinoButton.filled(
                      onPressed: () {
                        final name = controller.text.trim();
                        if (name.isNotEmpty) {
                          final newCategory = CategoryModels(
                            id: uuid.v4(),
                            name: name,
                          );
                          context.read<CategoryBloc>().add(
                            AddCategoryEvent(newCategory),
                          );
                          Navigator.pop(context);
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 60,
                      ),
                      child: const Text("Add", style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
  );
}
