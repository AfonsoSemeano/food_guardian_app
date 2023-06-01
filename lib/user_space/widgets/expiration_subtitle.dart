part of './item_entry.dart';

enum _HourglassColor { death, red, orange, green, empty }

class _ExpirationSubtitle extends StatelessWidget {
  _ExpirationSubtitle({
    super.key,
    required this.expirationDate,
  }) {
    _hourglassColor = _HourglassColor.empty;
    expirationPhrase = formatExpirationAndSetHourglass();
  }

  final DateTime? expirationDate;
  late _HourglassColor _hourglassColor;
  late String expirationPhrase;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          _hourglassColor == _HourglassColor.empty
              ? MdiIcons.clock
              : MdiIcons.clock,
          color: _hourglassColor == _HourglassColor.empty
              ? Colors.black
              : _hourglassColor == _HourglassColor.green
                  ? Colors.green
                  : _hourglassColor == _HourglassColor.orange
                      ? Colors.orange
                      : Colors.red,
        ),
        Text(expirationPhrase),
      ],
    );
  }

  String formatExpirationAndSetHourglass() {
    if (expirationDate != null) {
      final now = DateTime.now();
      final difference = expirationDate!.difference(now).abs();
      _hourglassColor = _HourglassColor.red;
      if (expirationDate!.isBefore(now)) {
        if (difference.inDays == 0) {
          return 'Today';
        } else if (difference.inDays == 1) {
          return '1 day old';
        } else if (difference.inDays < 7) {
          return '${difference.inDays} days old';
        } else if (difference.inDays < 30) {
          final weeks = (difference.inDays / 7).floor();
          if (weeks == 1) {
            return '1 week old';
          } else {
            return '$weeks weeks old';
          }
        } else if (difference.inDays < 365) {
          _hourglassColor = _HourglassColor.green;
          final months = (difference.inDays / 30).floor();
          if (months == 1) {
            return '1 month old';
          } else {
            return '$months months old';
          }
        } else {
          final years = (difference.inDays / 365).floor();
          if (years == 1) {
            return '1 year old';
          } else {
            return '$years years old';
          }
        }
      } else {
        if (difference.inDays == 1) {
          return '1 day ahead';
        } else if (difference.inDays < 7) {
          if (difference.inDays > 5) {
            _hourglassColor = _HourglassColor.orange;
          }
          return 'In ${difference.inDays} days';
        } else if (difference.inDays < 30) {
          if (difference.inDays < 9) {
            _hourglassColor = _HourglassColor.orange;
          } else {
            _hourglassColor = _HourglassColor.green;
          }
          final weeks = (difference.inDays / 7).floor();
          if (weeks == 1) {
            return 'In 1 week';
          } else {
            return 'In $weeks weeks';
          }
        } else if (difference.inDays < 365) {
          _hourglassColor = _HourglassColor.green;
          final months = (difference.inDays / 30).floor();
          if (months == 1) {
            return 'In 1 month';
          } else {
            return 'In $months months';
          }
        } else {
          _hourglassColor = _HourglassColor.green;
          final years = (difference.inDays / 365).floor();
          if (years == 1) {
            return 'In 1 year';
          } else {
            return 'In $years years';
          }
        }
      }
    } else {
      return '-';
    }
  }
}
