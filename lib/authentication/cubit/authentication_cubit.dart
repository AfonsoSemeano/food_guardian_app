import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:food_control_app/authentication/models/models.dart';
import 'package:formz/formz.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit(this._authenticationRepository)
      : super(const AuthenticationState());

  final AuthenticationRepository _authenticationRepository;

  void authTypeChanged({required bool isLogin}) {
    emit(
      state.copyWith(
        isLogin: isLogin,
        confirmPassword: const ConfirmPassword.pure(),
      ),
    );
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(email: email));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    var confirmedPassword =
        ConfirmPassword.pure(password: state.password.value);
    if (!state.confirmPassword.isPure) {
      confirmedPassword = ConfirmPassword.dirty(
        password: password.value,
        value: state.confirmPassword.value,
      );
    }
    emit(
      state.copyWith(password: password, confirmPassword: confirmedPassword),
    );
  }

  void confirmPasswordChanged(String password, String value) {
    final confirmPassword =
        ConfirmPassword.dirty(password: password, value: value);
    emit(state.copyWith(confirmPassword: confirmPassword));
  }

  Future<void> submitButtonPressed() async {
    if (Formz.validate([state.email, state.password, state.confirmPassword])) {
      return;
    }
    emit(state.copyWith(submissionStatus: FormzSubmissionStatus.inProgress));
    try {} on LogInWithEmailAndPasswordFailure catch (error) {}

    emit(state.copyWith(submissionStatus: FormzSubmissionStatus.inProgress));
    await Future.delayed(const Duration(seconds: 3), () {});
    emit(state.copyWith(submissionStatus: FormzSubmissionStatus.success));
  }
}
