import 'package:formz/formz.dart';

enum NameValidationError { tooBig, empty }

class Name extends FormzInput<String, NameValidationError> {
  const Name.pure() : super.pure('');
  const Name.dirty([super.value = '']) : super.dirty();

  static final nameRegex = RegExp(r'^.{1,60}$');

  @override
  NameValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return NameValidationError.empty;
    }

    if (!nameRegex.hasMatch(value)) {
      return NameValidationError.tooBig;
    }

    return null; // Return null when the value is valid
  }

  String? getErrorMessage() {
    if (error != null && !isPure) {
      switch (error!) {
        case NameValidationError.empty:
          return 'Cannot be empty!';
        case NameValidationError.tooBig:
          return 'Name too big!';
      }
    }
    return null;
  }
}
