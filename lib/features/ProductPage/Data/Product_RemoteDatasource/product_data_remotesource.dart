import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/models/product_model.dart';

class ProductDataRemotesource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  ProductDataRemotesource({required this.firestore, required this.storage});

  /// Adds a product to Firestore
  Future<void> addProduct(ProductModel product) async {
    try {
      var productRef = await firestore
          .collection('products')
          .add(product.toMap());
      product.id = productRef.id;
      await productRef.update({'id': product.id});
    } catch (e) {
      throw Exception('Error adding product: $e');
    }
  }

  /// Uploads multiple images to Cloudinary and returns the list of secure URLs
  Future<List<String>> uploadImages(List<File> imageFiles) async {
    List<String> imageUrls = [];

    for (File file in imageFiles) {
      try {
        final url = Uri.parse(
          "https://api.cloudinary.com/v1_1/ditsarti8/image/upload",
        );

        final request =
            http.MultipartRequest("POST", url)
              ..fields['upload_preset'] = 'glitchx_upload'
              ..fields['folder'] = 'products'
              ..files.add(await http.MultipartFile.fromPath('file', file.path));

        final response = await request.send();

        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          final jsonResponse = json.decode(responseBody);
          final imageUrl = jsonResponse['secure_url'] as String?;
          if (imageUrl != null) imageUrls.add(imageUrl);
        } else {
          log("Failed to upload image: ${response.statusCode}");
        }
      } catch (e) {
        log("Error uploading image: $e");
      }
    }

    return imageUrls;
  }

  /// Fetch all products from Firestore
  Future<List<ProductModel>> getProducts() async {
    try {
      final querySnapshot = await firestore.collection('products').get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  /// Update a product in Firestore
  Future<void> updateProduct(ProductModel product) async {
    try {
      await firestore.collection('products').doc(product.id).update({
        'name': product.name,
        'description': product.description,
        'category': product.category,
        'price': product.price,
        'stock': product.stock,
        'minSpecs': product.minSpecs,
        'recSpecs': product.recSpecs,
        'releaseDate': product.releaseDate,
        'imageUrls': product.imageUrls, // multiple image URLs
      });
    } catch (e) {
      throw Exception('Error updating product in Firestore: $e');
    }
  }

  /// Delete a product from Firestore
  Future<void> deleteProduct(String productId) async {
    try {
      await firestore.collection('products').doc(productId).delete();
    } catch (e) {
      throw Exception('Failed to delete the product: $e');
    }
  }

  /// Update only the image URLs of a product
  Future<void> updateProductImagesInFirestore(
    String productId,
    List<String> imageUrls,
  ) async {
    try {
      await firestore.collection('products').doc(productId).update({
        'imageUrls': imageUrls,
      });

      log("Updated product images: $imageUrls");

      var docSnapshot =
          await firestore.collection('products').doc(productId).get();
      log("Updated product data: ${docSnapshot.data()}");
    } catch (e) {
      log('Error updating product images in Firestore: $e');
      throw Exception('Error updating product images in Firestore: $e');
    }
  }
}
