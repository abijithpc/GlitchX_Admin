import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glitchx_admin/features/Category_Page/Domain/Models/category_models.dart';

class CategoryDropdown extends StatelessWidget {
  final List<CategoryModels> categoryModels;
  final String? selectedValue;
  final Function(String?) onChanged;

  const CategoryDropdown({
    required this.categoryModels,
    required this.selectedValue,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<String> categoryNames =
        categoryModels.map((category) => category.name).toList();

    return DropdownButtonFormField<String>(
      value: selectedValue,
      icon: const Icon(CupertinoIcons.chevron_down),
      decoration: InputDecoration(
        labelText: "Category",
        prefixIcon: const Icon(CupertinoIcons.cube_box_fill),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      items: categoryNames
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: (value) =>
          value == null || value.isEmpty ? "Please select Category" : null,
    );
  }
}
