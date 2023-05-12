import 'package:formz/formz.dart';

enum ConfirmationPasswordValidationError { invalid }

class ConfirmPassword
    extends FormzInput<String, ConfirmationPasswordValidationError> {
  const ConfirmPassword.pure({this.password = ''}) : super.pure('');

  const ConfirmPassword.dirty({required this.password, String value = ''})
      : super.dirty(value);

  final String password;

  @override
  ConfirmationPasswordValidationError? validator(String? value) {
    return password == value
        ? null
        : ConfirmationPasswordValidationError.invalid;
  }
}
