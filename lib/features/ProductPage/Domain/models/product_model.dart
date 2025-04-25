class ProductModel {
  final String name;
  final String description;
  final String category;
  final int price;
  final int stock;
  final int diskcount;
  final String minSpecs;
  final String recSpecs;
  final DateTime releaseDate;
  final String imageUrl;

  ProductModel({
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.stock,
    required this.diskcount,
    required this.minSpecs,
    required this.recSpecs,
    required this.releaseDate,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() => {
    "name": name,
    "description": description,
    "category": category,
    "imageUrl": imageUrl,
    "price": price,
    "Stock": stock,
    "diskCount": diskcount,
    "minSpecs": minSpecs,
    "recSpecs": recSpecs,
    "releaseDate": releaseDate,
  };
}
