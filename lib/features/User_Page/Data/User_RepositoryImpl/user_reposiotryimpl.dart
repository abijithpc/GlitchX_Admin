import 'package:glitchx_admin/features/User_Page/Data/User_RemoteDatasource/user_dataremotesource.dart';
import 'package:glitchx_admin/features/User_Page/Domain/Models/usermodel.dart';
import 'package:glitchx_admin/features/User_Page/Domain/User_repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataremotesource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Usermodel>> getUsers() {
    return remoteDataSource.fetchUsers();
  }

  @override
  Future<void> blockUser(String uid) {
    return remoteDataSource.updateBlockStatus(uid, true);
  }

  @override
  Future<void> unblockUser(String uid) {
    return remoteDataSource.updateBlockStatus(uid, false);
  }
}
