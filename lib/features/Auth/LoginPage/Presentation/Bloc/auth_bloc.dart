import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Domain/UseCase/admin_login_usecase.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Domain/UseCase/check_auth_status.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Presentation/Bloc/auth_event.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Presentation/Bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AdminLoginUsecase adminLoginUsecase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;

  AuthBloc({
    required this.adminLoginUsecase,
    required this.checkAuthStatusUseCase,
  }) : super(AuthIntial()) {
    on<AdminLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await adminLoginUsecase(email: event.email, password: event.password);
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          emit(AuthSuccess(uid));
        } else {
          emit(AuthFailure("User not Found After Login"));
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    //Check Login
    on<CheckAuthStatusEvent>((event, emit) async {
      final user = await checkAuthStatusUseCase();
      if(user !=null){
        await user.reload();
        final refreshedUser = FirebaseAuth.instance.currentUser;

        if (refreshedUser !=null && refreshedUser.emailVerified) {
          emit(AuthSuccess(refreshedUser.uid));
        }else{
          emit(AuthEmailNotVerified());
        }
      }else{
        emit(AuthIntial());
      }
    });
  }
}
