import 'package:flutter/services.dart';
import '../mixins/snackbar_mixin.dart';

class CalendarUtils with SnackbarMixin {
  static final CalendarUtils _instance = CalendarUtils._internal();
  factory CalendarUtils() => _instance;
  CalendarUtils._internal();

  /// Copie et prépare les informations d'un rendez-vous pour l'agenda natif
  void exportAppointmentToCalendar({
    required String doctorName,
    required String specialty,
    required String date,
    required String timeRange,
    String? cabinetAddress,
  }) {
    HapticFeedback.mediumImpact();

    final text = '''
📅 RENDEZ-VOUS MÉDICAL MEDIBOOK
Praticien: $doctorName ($specialty)
Date: $date
Heure: $timeRange
${cabinetAddress != null && cabinetAddress.isNotEmpty ? 'Lieu: $cabinetAddress' : ''}
''';

    Clipboard.setData(ClipboardData(text: text));

    _instance.showSuccess(
      'Copié dans le presse-papier !',
      'Informations du RDV avec $doctorName prêtes pour votre agenda.',
    );
  }
}
