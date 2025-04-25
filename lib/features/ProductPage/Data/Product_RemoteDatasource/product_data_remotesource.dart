import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glitchx_admin/Core/constant.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/models/product_model.dart';

class ProductDataRemotesource {
  final FirebaseFirestore firestore;

  ProductDataRemotesource({required this.firestore});

  Future<void> uploadProduct(ProductModel product) async {
    await firestore.collection('products').add(product.toMap());
  }

  Future<String> uploadImageTOCloudinary(File imageFile) async {
    final url = Uri.parse(cloudinarylink);
    final request =
        http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = 'products'
          ..files.add(
            await http.MultipartFile.fromPath('file', imageFile.path),
          );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final data = json.decode(responseBody);

    if (response.statusCode == 200) {
      return data['secure_url'];
    } else {
      throw Exception('Image upload failed: ${data['error']['message']}');
    }
  }
}
