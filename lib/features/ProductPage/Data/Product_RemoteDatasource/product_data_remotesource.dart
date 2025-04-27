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
      // Adding the product data to Firestore
      await firestore.collection('products').add(product.toMap());
    } catch (e) {
      // Catching any errors that occur during product addition
      throw Exception('Error adding product: $e');
    }
  }

  /// Uploads the image to Cloudinary and returns the secure URL
  Future<String?> uploadImage(File imageFile) async {
    try {
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/ditsarti8/image/upload",
      );

      final request =
          http.MultipartRequest("POST", url)
            ..fields['upload_preset'] = 'glitchx_upload'
            ..fields['folder'] = ':products'
            ..files.add(
              await http.MultipartFile.fromPath('file', imageFile.path),
            );

      final response = await request.send();
      log('${response.statusCode}');
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        return jsonResponse['secure_url'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      log("Response $e");
      return null;
    }
  }

  Future<List<ProductModel>> getProducts() async {
    try {
      final querySnapshot = await firestore.collection('products').get();
      log('$querySnapshot');
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

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
        'imageUrl': product.imageUrl, // Include imageUrl if updated
      });
    } catch (e) {
      throw Exception('Error updating product in Firestore: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await firestore.collection('products').doc(productId).delete();
    } catch (e) {
      throw Exception('Failed to Delete the Product : $e');
    }
  }

  // Future<void> updateProduct(ProductModel product) async {
  //   try {
  //     await firestore
  //         .collection('products')
  //         .doc(product.id)
  //         .update(product.toMap());
  //   } catch (e) {
  //     throw Exception('Error updating product in FireStore : $e');
  //   }
  // }

  Future<void> updateProductImageInFirestore(
    String productId,
    String imageUrl,
  ) async {
    try {
      await firestore
          .collection('products')
          .doc(productId)
          .update({'imageUrl': imageUrl})
          .then((_) async {
            log("Product image updated to: $imageUrl");

            // Fetch the document again to check if the update was successful
            var docSnapshot =
                await firestore.collection('products').doc(productId).get();
            log("Updated product data: ${docSnapshot.data()}");
            
          });
    } catch (e) {
      log('Error updating product image in Firestore: $e');
      throw Exception('Error updating product image in Firestore: $e');
    }
  }
}
