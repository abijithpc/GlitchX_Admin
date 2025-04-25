import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<void> loginAdmin({required String email, required String password});

  Future<User?> getCurrentUser();
}
