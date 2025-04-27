import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/models/product_model.dart';

class EditProductControllers {
  final TextEditingController name;
  final TextEditingController category;
  final TextEditingController price;
  final TextEditingController stock;
  final TextEditingController diskCount;
  final TextEditingController description;
  final TextEditingController minSpecs;
  final TextEditingController recSpecs;

  EditProductControllers({
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.diskCount,
    required this.description,
    required this.minSpecs,
    required this.recSpecs,
  });

  factory EditProductControllers.fromProduct(ProductModel product) {
    return EditProductControllers(
      name: TextEditingController(text: product.name),
      category: TextEditingController(text: product.category),
      price: TextEditingController(text: product.price.toString()),
      stock: TextEditingController(text: product.stock.toString()),
      diskCount: TextEditingController(text: product.diskCount.toString()),
      description: TextEditingController(text: product.description),
      minSpecs: TextEditingController(text: product.minSpecs),
      recSpecs: TextEditingController(text: product.recSpecs),
    );
  }

  ProductModel toProduct(String id, DateTime? releaseDate, String? imageUrl) {
    return ProductModel(
      id: id,
      name: name.text,
      category: category.text,
      price: int.parse(price.text),
      stock: int.parse(stock.text),
      diskCount: int.parse(diskCount.text),
      description: description.text,
      minSpecs: minSpecs.text,
      recSpecs: recSpecs.text,
      releaseDate: releaseDate ?? DateTime.now(),
      imageUrl: imageUrl ?? '',
    );
  }

  void dispose() {
    name.dispose();
    category.dispose();
    price.dispose();
    stock.dispose();
    diskCount.dispose();
    description.dispose();
    minSpecs.dispose();
    recSpecs.dispose();
  }
}

List<Widget> buildProductFields(EditProductControllers controllers) {
  return [
    _buildField('Product Name', CupertinoIcons.cube_box, controllers.name),
    _buildField('Category', CupertinoIcons.tag, controllers.category),
    _buildField('Price', CupertinoIcons.money_dollar_circle, controllers.price, type: TextInputType.number),
    _buildField('Stock', CupertinoIcons.cart, controllers.stock, type: TextInputType.number),
    _buildField('Disk Count', CupertinoIcons.floppy_disk, controllers.diskCount, type: TextInputType.number),
    _buildField('Description', CupertinoIcons.info_circle, controllers.description),
    _buildField('Minimum Specs', CupertinoIcons.settings, controllers.minSpecs),
    _buildField('Recommended Specs', CupertinoIcons.checkmark_seal, controllers.recSpecs),
  ];
}

Widget _buildField(String label, IconData icon, TextEditingController controller, {TextInputType type = TextInputType.text}) {
  return Container(
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
          child: TextField(
            controller: controller,
            keyboardType: type,
            decoration: InputDecoration(
              hintText: label,
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ),
      ],
    ),
  );
}
