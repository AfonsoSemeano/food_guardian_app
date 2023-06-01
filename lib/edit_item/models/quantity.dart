import 'package:formz/formz.dart';

enum QuantityValidationError { wrongFormatting, invalid, empty }

class Quantity extends FormzInput<String, QuantityValidationError> {
  const Quantity.pure() : super.pure('1');
  const Quantity.dirty([super.value = '1']) : super.dirty();

  @override
  QuantityValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return QuantityValidationError.empty;
    }

    if (int.tryParse(value) == null) {
      return QuantityValidationError.wrongFormatting;
    }
    final parsedValue = int.parse(value);

    if (parsedValue < 1) {
      return QuantityValidationError.invalid;
    }

    return null; // Return null when the value is valid
  }

  String? getErrorMessage() {
    if (error != null && !isPure) {
      switch (error!) {
        case QuantityValidationError.empty:
          return 'Cannot be empty!';
        case QuantityValidationError.wrongFormatting:
          return 'Must be an integer!';
        case QuantityValidationError.invalid:
          return 'Must be 1 or more!';
      }
    }
    return null;
  }
}
