import 'package:formz/formz.dart';

enum NameValidationError { invalid }

class Name extends FormzInput<String, NameValidationError> {
  const Name.pure() : super.pure('');
  const Name.dirty([super.value = '']) : super.dirty();

  static final nameRegex = RegExp(r'^.{1,40}$');

  @override
  NameValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return null; // No validation error for empty value
    }

    if (!nameRegex.hasMatch(value)) {
      return NameValidationError.invalid;
    }

    return null; // Return null when the value is valid
  }
}
