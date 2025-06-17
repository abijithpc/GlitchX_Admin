import 'package:glitchx_admin/features/UserPage/Domain/User_repository/user_repository.dart';

class UnblockUserUseCase {
  final UserRepository repository;
  UnblockUserUseCase(this.repository);

  Future<void> call(String uid) => repository.unblockUser(uid);
}
