import 'package:firebase_auth/firebase_auth.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Data/Auth_RemoteDatasource/auth_remote_datasource.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Domain/Auth_repository/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final FirebaseAuth firebaseAuth;

  AuthRepositoryImpl(this.remoteDatasource, this.firebaseAuth);

  @override
  Future<void> loginAdmin({
    required String email,
    required String password,
  }) async {
    return await remoteDatasource.loginAdmin(email: email, password: password);
  }

  @override
  Future<User?> getCurrentUser() async {
    return firebaseAuth.currentUser;
  }
}
