// lib/features/ProductPage/Presentation/widgets/add_product_form.dart
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/features/Product_Page/Domain/models/product_model.dart';
import 'package:glitchx_admin/features/Product_Page/Presentation/Bloc/product_bloc.dart';
import 'package:glitchx_admin/features/Product_Page/Presentation/Bloc/product_event.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddProductForm extends StatefulWidget {
  final List<String> categories;
  const AddProductForm({super.key, required this.categories});

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _diskCountController = TextEditingController();
  final TextEditingController _minSpecsController = TextEditingController();
  final TextEditingController _recSpecsController = TextEditingController();

  List<File> _imageFile = [];
  String? _selectedCategory;
  DateTime? _releaseDate;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickMultiImage(imageQuality: 80);
    setState(
      () => _imageFile = pickedFile.map((xfile) => File(xfile.path)).toList(),
    );
  }

  Future<void> _pickReleaseDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _releaseDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildImagePicker(),
          _spacer(),
          _buildField(
            "Game Name",
            CupertinoIcons.game_controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            _nameController,
            validator: (value) {
              String pattern = r'^[a-zA-Z0-9_]+$';
              RegExp regExp = RegExp(pattern);
              if (value == null || value.isEmpty) {
                return "Enter Product Name Name";
              }
              if (!regExp.hasMatch(value)) {
                return 'Only letters, numbers & underscores allowed';
              }
              return null;
            },
          ),
          _spacer(),
          _buildField(
            "Description",
            autovalidateMode: AutovalidateMode.onUserInteraction,
            CupertinoIcons.doc_text_fill,
            _descController,
            maxLines: 3,
            validator:
                (value) =>
                    value == null || value.isEmpty ? "Enter description" : null,
          ),
          _spacer(),
          _buildDropdown(
            "Category",
            CupertinoIcons.cube_box_fill,
            widget.categories,
            validator: (value) => value == null ? "Select category" : null,
          ),
          _spacer(),
          _buildField(
            "Disk Count",
            CupertinoIcons.number,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            _diskCountController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Enter disk count";
              } else if (int.tryParse(value) == null) {
                return "Enter a valid number for disk count";
              }
              return null;
            },
          ),
          _spacer(),
          _buildField(
            "Price (₹)",
            CupertinoIcons.money_dollar,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            _priceController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Enter price";
              } else if (double.tryParse(value) == null) {
                return "Enter a valid price";
              }
              return null;
            },
          ),
          _spacer(),
          _buildField(
            "Stock",
            CupertinoIcons.archivebox_fill,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            _stockController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Enter stock quantity";
              } else if (int.tryParse(value) == null) {
                return "Enter a valid stock number";
              }
              return null;
            },
          ),
          _spacer(),
          _buildField(
            "Minimum Specs",
            CupertinoIcons.memories,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            _minSpecsController,
            maxLines: 2,
            validator:
                (value) =>
                    value == null || value.isEmpty
                        ? "Enter minimum specs"
                        : null,
          ),
          _spacer(),
          _buildField(
            "Recommended Specs",
            CupertinoIcons.star_fill,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            _recSpecsController,
            maxLines: 2,
            validator:
                (value) =>
                    value == null || value.isEmpty
                        ? "Enter recommended specs"
                        : null,
          ),
          _spacer(),
          InkWell(
            onTap: _pickReleaseDate,
            child: InputDecorator(
              decoration: _inputDecoration(
                "Release Date",
                CupertinoIcons.calendar,
              ),
              child: Text(
                _releaseDate != null
                    ? DateFormat.yMMMd().format(_releaseDate!)
                    : "Tap to pick a date",
                style: TextStyle(
                  color:
                      _releaseDate != null
                          ? CupertinoColors.black
                          : CupertinoColors.systemGrey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          CupertinoButton.filled(
            onPressed: _onSubmit,
            child: const Text("Add Product", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null ||
        _releaseDate == null ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields")),
      );
      return;
    }

    final product = ProductModel(
      name: _nameController.text.trim(),
      category: _selectedCategory!,
      description: _descController.text.trim(),
      price: int.parse(_priceController.text),
      stock: int.parse(_stockController.text),
      diskCount: int.parse(_diskCountController.text),
      minSpecs: _minSpecsController.text.trim(),
      recSpecs: _recSpecsController.text.trim(),
      releaseDate: _releaseDate!,
      imageUrls: [],
    );

    context.read<ProductBloc>().add(
      UploadProductEvent(product: product, image: _imageFile),
    );
    Navigator.pop(context);
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: DottedBorder(
        color: CupertinoColors.activeBlue,
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        dashPattern: [6, 3],
        child: Container(
          height: 180,
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child:
              _imageFile.isNotEmpty
                  ? GridView.builder(
                    itemCount: _imageFile.length,
                    scrollDirection: Axis.horizontal,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 1,
                          mainAxisSpacing: 8,
                        ),
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _imageFile[index],
                              fit: BoxFit.cover,
                              width: 140,
                              height: 140,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() => _imageFile.removeAt(index));
                              },
                              child: const CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.black54,
                                child: Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                  : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.photo_on_rectangle,
                          size: 40,
                          color: CupertinoColors.activeBlue,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Tap to upload image(s)",
                          style: TextStyle(color: CupertinoColors.activeBlue),
                        ),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    IconData icon,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    AutovalidateMode? autovalidateMode,
  }) {
    return TextFormField(
      autovalidateMode: autovalidateMode,
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: _inputDecoration(label, icon),
    );
  }

  Widget _buildDropdown(
    String label,
    IconData icon,
    List<String> items, {
    required String? Function(String?) validator,
  }) {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      onChanged: (val) => setState(() => _selectedCategory = val),
      validator: validator,
      decoration: _inputDecoration(label, icon),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey[100],
    );
  }

  SizedBox _spacer() => const SizedBox(height: 15);
}
