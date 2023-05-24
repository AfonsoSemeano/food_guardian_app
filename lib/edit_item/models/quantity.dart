import 'package:formz/formz.dart';

enum QuantityValidationError { invalid }

class Quantity extends FormzInput<int, QuantityValidationError> {
  const Quantity.pure() : super.pure(1);
  const Quantity.dirty([super.value = 1]) : super.dirty();

  @override
  QuantityValidationError? validator(int? value) {
    if (value == null) {
      return null; // No validation error for empty value
    }

    if (value < 1) {
      return QuantityValidationError.invalid;
    }

    return null; // Return null when the value is valid
  }
}
