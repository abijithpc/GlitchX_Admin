// lib/features/ProductPage/Presentation/widgets/add_product_form.dart
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/models/product_model.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/Bloc/product_bloc.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/Bloc/product_event.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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

  File? _imageFile;
  String? _selectedCategory;
  DateTime? _releaseDate;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) setState(() => _imageFile = File(pickedFile.path));
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
          _buildField("Game Name", CupertinoIcons.game_controller, _nameController),
          _spacer(),
          _buildField("Description", CupertinoIcons.doc_text_fill, _descController, maxLines: 3),
          _spacer(),
          _buildDropdown("Category", CupertinoIcons.cube_box_fill, widget.categories),
          _spacer(),
          _buildField("Disk Count", CupertinoIcons.number, _diskCountController, keyboardType: TextInputType.number),
          _spacer(),
          _buildField("Price (₹)", CupertinoIcons.money_dollar, _priceController, keyboardType: TextInputType.number),
          _spacer(),
          _buildField("Stock", CupertinoIcons.archivebox_fill, _stockController, keyboardType: TextInputType.number),
          _spacer(),
          _buildField("Minimum Specs", CupertinoIcons.memories, _minSpecsController, maxLines: 2),
          _spacer(),
          _buildField("Recommended Specs", CupertinoIcons.star_fill, _recSpecsController, maxLines: 2),
          _spacer(),
          InkWell(
            onTap: _pickReleaseDate,
            child: InputDecorator(
              decoration: _inputDecoration("Release Date", CupertinoIcons.calendar),
              child: Text(
                _releaseDate != null ? DateFormat.yMMMd().format(_releaseDate!) : "Tap to pick a date",
                style: TextStyle(color: _releaseDate != null ? CupertinoColors.black : CupertinoColors.systemGrey),
              ),
            ),
          ),
          const SizedBox(height: 30),
          CupertinoButton.filled(
            onPressed: _onSubmit,
            child: const Text("Add Product", style: TextStyle(fontSize: 18)),
          )
        ],
      ),
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null || _releaseDate == null || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please complete all fields")));
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
      imageUrl: "",
    );

    context.read<ProductBloc>().add(UploadProductEvent(product: product, image: _imageFile!));
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
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
          child: _imageFile != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(_imageFile!, fit: BoxFit.contain),
                )
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.photo_on_rectangle, size: 40, color: CupertinoColors.activeBlue),
                      SizedBox(height: 10),
                      Text("Tap to upload image", style: TextStyle(color: CupertinoColors.activeBlue)),
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
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) => value == null || value.isEmpty ? "Enter $label" : null,
      decoration: _inputDecoration(label, icon),
    );
  }

  Widget _buildDropdown(String label, IconData icon, List<String> items) {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      onChanged: (val) => setState(() => _selectedCategory = val),
      validator: (val) => val == null ? "Select $label" : null,
      decoration: _inputDecoration(label, icon),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
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
