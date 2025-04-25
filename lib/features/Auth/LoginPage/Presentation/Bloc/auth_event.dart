abstract class AuthEvent {}

class AdminLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AdminLoginRequested({required this.email, required this.password});
}

class CheckAuthStatusEvent extends AuthEvent {}
