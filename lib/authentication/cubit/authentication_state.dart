part of 'authentication_cubit.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.submissionStatus = FormzSubmissionStatus.initial,
    this.isLogin = false,
    this.errorMessage,
  });

  final Email email;
  final Password password;
  final ConfirmPassword confirmPassword;
  final FormzSubmissionStatus submissionStatus;
  final bool isLogin;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        email,
        password,
        confirmPassword,
        submissionStatus,
        isLogin,
        errorMessage
      ];

  AuthenticationState copyWith({
    Email? email,
    Password? password,
    ConfirmPassword? confirmPassword,
    FormzSubmissionStatus? submissionStatus,
    bool? isLogin,
    String? errorMessage,
  }) {
    return AuthenticationState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      isLogin: isLogin ?? this.isLogin,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool validateInputs() {
    if (isLogin) {
      return Formz.validate([email, password]);
    }
    return Formz.validate([email, password, confirmPassword]);
  }
}
