part of 'authentication_cubit.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isLogin = true,
  });

  final Email email;
  final Password password;
  final ConfirmPassword confirmPassword;
  final FormzSubmissionStatus status;
  final bool isLogin;

  @override
  List<Object> get props => [];
}
