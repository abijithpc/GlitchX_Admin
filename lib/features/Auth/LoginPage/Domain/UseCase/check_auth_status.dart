import 'package:firebase_auth/firebase_auth.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Domain/Auth_repository/auth_repository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  Future<User?> call() async {
    return await repository.getCurrentUser();
  }
}
