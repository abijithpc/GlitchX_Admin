import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/Core/Widgets/ScreenBackground/screen_background.dart';
import 'package:glitchx_admin/features/Category_Page/Domain/Models/category_models.dart';
import 'package:glitchx_admin/features/Category_Page/Presentation/Bloc/category_bloc.dart';
import 'package:glitchx_admin/features/Category_Page/Presentation/Bloc/category_event.dart';
import 'package:glitchx_admin/features/Category_Page/Presentation/Bloc/category_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
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

  @override
  void initState() {
    super.initState();
    // 🔁 Trigger load categories
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<void> _pickReleaseDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _releaseDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CupertinoNavigationBar(
        middle: const Text("Add New Game"),
        backgroundColor: CupertinoColors.black,
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return Center(child: CupertinoActivityIndicator());
          } else if (state is CategoryError) {
            return Center(child: Text(state.message));
          } else if (state is CategoryLoaded && state.categories.isEmpty) {
            return Center(child: Text("No Categories Found"));
          } else if (state is CategoryLoaded) {
            final categories = state.categories.map((e) => e.name).toList();
            return ScreenBackGround(
              widget: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImagePicker(),
                      const SizedBox(height: 20),
                      _buildField(
                        "Game Name",
                        CupertinoIcons.game_controller,
                        _nameController,
                      ),
                      const SizedBox(height: 15),
                      _buildField(
                        "Description",
                        CupertinoIcons.doc_text_fill,
                        _descController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 15),
                      _buildDropdown(
                        "Category",
                        CupertinoIcons.cube_box_fill,
                        categories,
                        _selectedCategory,
                        (val) {
                          setState(() => _selectedCategory = val);
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildField(
                        "Disk Count",
                        CupertinoIcons.number,
                        _diskCountController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 15),
                      _buildField(
                        "Price (₹)",
                        CupertinoIcons.money_dollar,
                        _priceController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 15),
                      _buildField(
                        "Stock",
                        CupertinoIcons.archivebox_fill,
                        _stockController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 15),
                      _buildField(
                        "Minimum Specs",
                        CupertinoIcons.memories,
                        _minSpecsController,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 15),
                      _buildField(
                        "Recommended Specs",
                        CupertinoIcons.star_fill,
                        _recSpecsController,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: _pickReleaseDate,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: "Release Date",
                            prefixIcon: const Icon(CupertinoIcons.calendar),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
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
                      Center(
                        child: CupertinoButton.filled(
                          onPressed: () {},
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),
                          child: const Text(
                            "Add Product",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              screenHeight: screenHeight,
              screenWidth: screenWidth,
            );
          }
          // Get categories from the state

          return Container();
        },
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: DottedBorder(
        color: CupertinoColors.activeBlue,
        strokeWidth: 2,
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        dashPattern: [6, 3],
        child: Container(
          height: 180,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child:
              _imageFile != null
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _imageFile!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 180,
                    ),
                  )
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        CupertinoIcons.photo_on_rectangle,
                        size: 40,
                        color: CupertinoColors.activeBlue,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Tap to upload image",
                        style: TextStyle(
                          fontSize: 16,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                    ],
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
      validator:
          (value) =>
              value == null || value.isEmpty ? "Please enter $label" : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    IconData icon,
    List<String> categoryModels,
    String? selectedValue,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      icon: const Icon(CupertinoIcons.chevron_down),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      items:
          categoryModels
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
      onChanged: onChanged,
      validator:
          (value) =>
              value == null || value.isEmpty ? "Please select $label" : null,
    );
  }
}
