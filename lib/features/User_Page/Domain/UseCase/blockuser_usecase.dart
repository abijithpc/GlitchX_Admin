import 'package:glitchx_admin/features/User_Page/Domain/User_repository/user_repository.dart';

class BlockUserUseCase {
  final UserRepository repository;
  BlockUserUseCase(this.repository);

  Future<void> call(String uid) => repository.blockUser(uid);
}
