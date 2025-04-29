import 'dart:io';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/Core/Widgets/ScreenBackground/screen_background.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/models/product_model.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/Bloc/product_bloc.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/Bloc/product_event.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/Bloc/product_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditProductPage extends StatefulWidget {
  final ProductModel product;
  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final ImagePicker _imagePicker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _diskCountController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _minSpecsController = TextEditingController();
  final TextEditingController _recSpecsController = TextEditingController();

  DateTime? _releaseDate;
  String? _imageUrl;
  File? _imageFile;
  String? _newImageUrl; // To store new image URL

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();

    _nameController.text = widget.product.name;
    _categoryController.text = widget.product.category;
    _priceController.text = widget.product.price.toString();
    _descriptionController.text = widget.product.description;
    _diskCountController.text = widget.product.diskCount.toString();
    _stockController.text = widget.product.stock.toString();
    _minSpecsController.text = widget.product.minSpecs;
    _recSpecsController.text = widget.product.recSpecs;
    _releaseDate = widget.product.releaseDate;
    _imageUrl = widget.product.imageUrl;
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _diskCountController.dispose();
    _stockController.dispose();
    _minSpecsController.dispose();
    _recSpecsController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    String updatedImageUrl = widget.product.imageUrl;

    // If the user has selected a new image, upload it to Firebase and get the URL
    if (_imageFile != null) {
      updatedImageUrl = await _uploadImageToFirebase(
        _imageFile!,
      ); // Upload image to Firebase and get the URL
    }

    final updatedProduct = ProductModel(
      id: widget.product.id,
      name: _nameController.text,
      description: _descriptionController.text,
      category: _categoryController.text,
      diskCount: int.parse(_diskCountController.text),
      price: int.parse(_priceController.text),
      stock: int.parse(_stockController.text),
      minSpecs: _minSpecsController.text,
      recSpecs: _recSpecsController.text,
      releaseDate: _releaseDate ?? DateTime.now(),
      imageUrl: updatedImageUrl, // Use the updated image URL here
    );

    context.read<ProductBloc>().add(EditProductEvent(updatedProduct));
  }

  Future<String> _uploadImageToFirebase(File imageFile) async {
    // Example: Upload to Firebase Storage
    final storageRef = FirebaseStorage.instance.ref().child(
      'products/${widget.product.id}/${DateTime.now().toString()}.jpg',
    );
    await storageRef.putFile(imageFile);
    final downloadUrl = await storageRef.getDownloadURL();
    return downloadUrl; // Return the Firebase URL of the uploaded image
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType type = TextInputType.text,
  }) {
    return AnimatedOpacity(
      opacity: 1,
      duration: const Duration(milliseconds: 500),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(128),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withAlpha(38),
              blurRadius: 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.deepPurple, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: type,
                style: const TextStyle(color: Colors.black87, fontSize: 16),
                decoration: InputDecoration(
                  hintText: label,
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: () async {
        final image = await _imagePicker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          setState(() {
            _imageFile = File(image.path);
            _imageUrl = null; // Set _imageUrl to null to indicate a new image
          });
          context.read<ProductBloc>().add(
            EditProductImageSubmitted(
              imageFile: _imageFile!,
              productId: widget.product.id!,
            ),
          );
        }
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image:
                  _imageFile != null
                      ? DecorationImage(
                        image: FileImage(_imageFile!),
                        fit: BoxFit.cover,
                      )
                      : (_imageUrl != null
                          ? DecorationImage(
                            image: NetworkImage(_imageUrl!),
                            fit: BoxFit.cover,
                          )
                          : const DecorationImage(
                            image: AssetImage('assets/images/placeholder.png'),
                            fit: BoxFit.cover,
                          )),
              color: Colors.grey.withAlpha(77),
            ),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: Colors.black.withAlpha(66),
                  child: const Text(
                    'Change Image',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _releaseDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _releaseDate) {
      setState(() {
        _releaseDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: ScreenBackGround(
        widget: FadeTransition(
          opacity: _fadeAnimation,
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is Productloading) {
                return Center(
                  child: CupertinoActivityIndicator(color: Colors.white),
                );
              } else if (state is ProductLoaded) {
                return SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CupertinoNavigationBar(
                          middle: Text(
                            'Edit Product',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          backgroundColor: Colors.transparent,
                          border: null,
                        ),
                        const SizedBox(height: 20),
                        _buildImagePicker(),
                        const SizedBox(height: 20),
                        _buildTextField(
                          label: 'Product Name',
                          icon: CupertinoIcons.cube_box,
                          controller: _nameController,
                        ),
                        _buildTextField(
                          label: 'Category',
                          icon: CupertinoIcons.tag,
                          controller: _categoryController,
                        ),
                        _buildTextField(
                          label: 'Price',
                          icon: CupertinoIcons.money_dollar_circle,
                          controller: _priceController,
                          type: TextInputType.number,
                        ),
                        _buildTextField(
                          label: 'Stock',
                          icon: CupertinoIcons.cart,
                          controller: _stockController,
                          type: TextInputType.number,
                        ),
                        _buildTextField(
                          label: 'Disk Count',
                          icon: CupertinoIcons.floppy_disk,
                          controller: _diskCountController,
                          type: TextInputType.number,
                        ),
                        _buildTextField(
                          label: 'Description',
                          icon: CupertinoIcons.info_circle,
                          controller: _descriptionController,
                        ),
                        _buildTextField(
                          label: 'Minimum Specs',
                          icon: CupertinoIcons.settings,
                          controller: _minSpecsController,
                        ),
                        _buildTextField(
                          label: 'Recommended Specs',
                          icon: CupertinoIcons.checkmark_seal,
                          controller: _recSpecsController,
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: _selectDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(128),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurple.withAlpha(38),
                                  blurRadius: 8,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.calendar_today,
                                  color: Colors.deepPurple,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _releaseDate == null
                                        ? 'Select Release Date'
                                        : DateFormat(
                                          'dd/MM/yyyy',
                                        ).format(_releaseDate!),
                                    style: TextStyle(
                                      color:
                                          _releaseDate == null
                                              ? Colors.grey[600]
                                              : Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: CupertinoButton(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.25,
                              vertical: 16,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.deepPurple.withAlpha(204),
                            onPressed: () {
                              _saveChanges();
                              Navigator.pop(context);
                              showCupertinoDialog(
                                context: context,
                                builder:
                                    (context) => CupertinoAlertDialog(
                                      title: const Text('Product Updated'),
                                      content: const Text(
                                        'Your changes have been saved successfully!',
                                      ),
                                      actions: [
                                        CupertinoDialogAction(
                                          isDefaultAction: true,
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                              );
                            },
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                );
              } else if (state is ProductFailure) {
                return Center(child: Text(state.message));
              } else {
                return Center(child: Text('No data Available'));
              }
            },
          ),
        ),
        screenHeight: screenHeight,
        screenWidth: screenWidth,
      ),
    );
  }
}
