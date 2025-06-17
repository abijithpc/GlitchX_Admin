import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/features/UserPage/Domain/UseCase/blockuser_usecase.dart';
import 'package:glitchx_admin/features/UserPage/Domain/UseCase/get_user_usecase.dart';
import 'package:glitchx_admin/features/UserPage/Domain/UseCase/unblocuser_usecase.dart';
import 'package:glitchx_admin/features/UserPage/Presentation/Bloc/user_event.dart';
import 'package:glitchx_admin/features/UserPage/Presentation/Bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUseCase getUsers;
  final BlockUserUseCase blockUser;
  final UnblockUserUseCase unblockUser;

  UserBloc(this.getUsers, this.blockUser, this.unblockUser)
    : super(UserInitial()) {
    on<FetchUsers>((event, emit) async {
      emit(UserLoading());
      try {
        final users = await getUsers();
        emit(UserLoaded(users));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<BlockUser>((event, emit) async {
      await blockUser(event.uid);
      add(FetchUsers());
    });

    on<UnblockUser>((event, emit) async {
      await unblockUser(event.uid);
      add(FetchUsers());
    });
  }
}
