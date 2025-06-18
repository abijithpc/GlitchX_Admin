import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glitchx_admin/features/User_Page/Domain/Models/usermodel.dart';

class UserDataremotesource {
  final FirebaseFirestore _firestore;

  UserDataremotesource(this._firestore);
  Future<List<Usermodel>> fetchUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs
        .map((doc) => Usermodel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> updateBlockStatus(String uid, bool isBlocked) async {
    await _firestore.collection('users').doc(uid).update({
      'isBlocked': isBlocked,
    });
  }
}
