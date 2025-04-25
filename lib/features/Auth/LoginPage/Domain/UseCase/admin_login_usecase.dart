import 'package:glitchx_admin/features/Auth/LoginPage/Domain/Auth_repository/auth_repository.dart';

class AdminLoginUsecase {
  final AuthRepository repository;

  AdminLoginUsecase(this.repository);

  Future<void> call({required String email, required String password}) async {
    return await repository.loginAdmin(email: email, password: password);
  }
}
