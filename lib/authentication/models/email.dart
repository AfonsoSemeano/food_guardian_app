import 'package:formz/formz.dart';

enum EmailValidationError { invalid }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');

  const Email.dirty([super.value = '']) : super.dirty();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*\.com$',
  );

  @override
  EmailValidationError? validator(String? value) {
    final trimmedValue = value != null ? value.trim() : '';
    return _emailRegExp.hasMatch(trimmedValue)
        ? null
        : EmailValidationError.invalid;
  }
}
