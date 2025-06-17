import 'package:glitchx_admin/features/UserPage/Domain/Models/usermodel.dart';

abstract class UserRepository {
  Future<List<Usermodel>> getUsers();
  Future<void> blockUser(String uid);
  Future<void> unblockUser(String uid);
}
