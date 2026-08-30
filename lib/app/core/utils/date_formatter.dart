import 'package:intl/intl.dart';

class DateFormatter {
  /// Format a string like "2026-08-17" or "17/08/2026" to "Lundi 17 Août 2026"
  static String formatFullFrenchDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '';
    final dt = parseDate(rawDate);
    if (dt == null) return rawDate;

    try {
      final formatted = DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(dt);
      return _capitalizeWords(formatted);
    } catch (_) {
      try {
        final formatted = DateFormat('EEEE d MMMM yyyy', 'en_US').format(dt);
        return _capitalizeWords(formatted);
      } catch (_) {
        return rawDate;
      }
    }
  }

  /// Format a string like "2026-08-17" to "Lun. 17 Aoû"
  static String formatShortFrenchDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '';
    final dt = parseDate(rawDate);
    if (dt == null) return rawDate;

    try {
      final formatted = DateFormat('EEE d MMM', 'fr_FR').format(dt);
      return _capitalizeWords(formatted);
    } catch (_) {
      return rawDate;
    }
  }

  static DateTime? parseDate(String dateStr) {
    try {
      if (dateStr.contains('-')) {
        return DateTime.parse(dateStr);
      } else if (dateStr.contains('/')) {
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          return DateTime.parse(
            '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}',
          );
        }
      }
    } catch (_) {}
    return null;
  }

  static String _capitalizeWords(String input) {
    if (input.isEmpty) return input;
    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return '${word[0].toUpperCase()}${word.substring(1)}';
    }).join(' ');
  }
}
