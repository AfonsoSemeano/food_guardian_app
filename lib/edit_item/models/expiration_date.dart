import 'package:formz/formz.dart';

enum ExpirationDateValidationError {
  invalidFormat,
  invalidMonth,
  invalidDay,
  invalidYear,
  invalidLeapYear,
  invalidDayOfMonth,
}

class ExpirationDate extends FormzInput<String, ExpirationDateValidationError> {
  const ExpirationDate.pure() : super.pure('');
  const ExpirationDate.dirty([super.value = '']) : super.dirty();

  static final _expirationDateRegex = RegExp(
    r'^\d{2}/\d{2}/\d{4}$', // Assumes expiration date format as 'MM/DD/YYYY'
  );

  @override
  ExpirationDateValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return null; // No validation error for empty value
    }

    if (!_expirationDateRegex.hasMatch(value)) {
      return ExpirationDateValidationError
          .invalidFormat; // Invalid expiration date format
    }

    final parts = value.split('/');
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (month == null || month < 1 || month > 12) {
      return ExpirationDateValidationError.invalidMonth; // Invalid month
    }

    if (day == null || day < 1 || day > 31) {
      return ExpirationDateValidationError.invalidDay; // Invalid day
    }

    if (year == null || year < 1) {
      return ExpirationDateValidationError.invalidYear; // Invalid year
    }

    // Check for leap year
    if (month == 2 && day == 29) {
      if (!(year % 4 == 0 && (year % 100 != 0 || year % 400 == 0))) {
        return ExpirationDateValidationError
            .invalidLeapYear; // Invalid leap year
      }
    }

    // Check the number of days in each month
    final daysInMonth = <int, int>{
      1: 31,
      2: (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) ? 29 : 28,
      3: 31,
      4: 30,
      5: 31,
      6: 30,
      7: 31,
      8: 31,
      9: 30,
      10: 31,
      11: 30,
      12: 31,
    };

    if (day > daysInMonth[month]!) {
      return ExpirationDateValidationError
          .invalidDayOfMonth; // Invalid day for the given month
    }

    return null; // Return null when the value is valid
  }
}
