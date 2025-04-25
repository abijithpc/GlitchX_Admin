import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String name;
  final String description;
  final String category;
  final int diskCount;
  final int price;
  final int stock;
  final String minSpecs;
  final String recSpecs;
  final DateTime releaseDate;
  final String imageUrl;

  ProductModel({
    required this.name,
    required this.description,
    required this.category,
    required this.diskCount,
    required this.price,
    required this.stock,
    required this.minSpecs,
    required this.recSpecs,
    required this.releaseDate,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'diskCount': diskCount,
      'price': price,
      'stock': stock,
      'minSpecs': minSpecs,
      'recSpecs': recSpecs,
      'releaseDate': releaseDate,
      'imageUrl': imageUrl,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: map['name'],
      description: map['description'],
      category: map['category'],
      diskCount: map['diskCount'],
      price: map['price'],
      stock: map['stock'],
      minSpecs: map['minSpecs'],
      recSpecs: map['recSpecs'],
      releaseDate: _fromTimestap(map['releaseDate']),
      imageUrl: map['imageUrl'],
    );
  }

  static DateTime _fromTimestap(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    return DateTime.now();
  }
}
