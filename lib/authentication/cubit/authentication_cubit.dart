import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:food_control_app/authentication/models/models.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart';
import 'package:formz/formz.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit(
    this._authenticationRepository,
    this._foodSpacesRepository,
  ) : super(const AuthenticationState());

  final AuthenticationRepository _authenticationRepository;
  final FoodSpacesRepository _foodSpacesRepository;

  void authTypeChanged({required bool isLogin}) {
    emit(
      state.copyWith(
        isLogin: isLogin,
        confirmPassword: ConfirmPassword.pure(password: state.password.value),
        errorMessage: '',
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
    if (!Formz.validate([state.email, state.password])) {
      return;
    }
    if (!state.isLogin && !Formz.validate([state.confirmPassword])) {
      return;
    }
    emit(state.copyWith(submissionStatus: FormzSubmissionStatus.inProgress));
    try {
      if (state.isLogin) {
        await _authenticationRepository.loginWithEmailAndPassword(
          email: state.email.value,
          password: state.password.value,
        );
        emit(state.copyWith(submissionStatus: FormzSubmissionStatus.success));
      } else {
        final userId = await _authenticationRepository.signUp(
          email: state.email.value,
          password: state.password.value,
        );
        _foodSpacesRepository.createDefaultFoodSpace(userId);
        // emit(state.copyWith(submissionStatus: FormzSubmissionStatus.success));
      }
    } on AuthenticationRepositoryFailure catch (error) {
      emit(
        state.copyWith(
          errorMessage: error.message,
          submissionStatus: FormzSubmissionStatus.failure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(submissionStatus: FormzSubmissionStatus.failure));
    }
  }
}
