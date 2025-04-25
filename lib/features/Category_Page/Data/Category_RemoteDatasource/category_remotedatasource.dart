import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glitchx_admin/features/Category_Page/Domain/Models/category_models.dart';

class CategoryRemotedatasource {
  final FirebaseFirestore firestore;

  CategoryRemotedatasource({required this.firestore});

  Future<void> addCategory(CategoryModels category) async {
    await firestore
        .collection('categories')
        .doc(category.id)
        .set(category.toJson());
  }

  Future<List<CategoryModels>> fetchCategories() async {
    final snapshot = await firestore.collection('categories').get();
    return snapshot.docs
        .map((doc) => CategoryModels.fromJson(doc.data()))
        .toList();
  }
}
