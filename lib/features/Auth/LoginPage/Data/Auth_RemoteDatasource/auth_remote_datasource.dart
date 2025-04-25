import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDatasource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDatasource(this._firebaseAuth);

  Future<void> loginAdmin({
    required String email,
    required String password,
  }) async {
    if (email == 'holicwork545@gmail.com' && password == 'Admin@123') {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } else {
      throw FirebaseAuthException(
        code: "unauthorized",
        message: "Invalid admin credentials",
      );
    }
  }
}
