import 'package:glitchx_admin/features/UserPage/Domain/Models/usermodel.dart';
import 'package:glitchx_admin/features/UserPage/Domain/User_repository/user_repository.dart';

class GetUsersUseCase {
  final UserRepository repository;
  GetUsersUseCase(this.repository);

  Future<List<Usermodel>> call() => repository.getUsers();
}
