class CategoryModels {
  final String id;
  final String name;

  CategoryModels({required this.id, required this.name});

  factory CategoryModels.fromJson(Map<String, dynamic> json) {
    return CategoryModels(id: json['id'] ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() => {'name': name};
}
