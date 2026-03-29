import 'dart:io';
import 'package:get/get.dart';
import '../../translate/translation_keys.dart';

/// Utilitaire pour extraire et humaniser les messages d'erreur.
class ErrorUtils {
  /// Extrait un message lisible depuis la réponse du backend.
  /// Le backend Java retourne : { "error": "...", "message": "..." }
  /// ou parfois : { "errors": { "email": "...", "password": "..." } }
  static String extractApiError(Response response, String fallback) {
    final body = response.body;
    if (body == null) return fallback;

    if (body is Map) {
      // 1) Vérifier le champ "errors" (validation DTO backend)
      if (body.containsKey('errors') && body['errors'] is Map) {
        final errors = body['errors'] as Map;
        // Joindre tous les messages de validation
        final messages = errors.values
            .where((v) => v != null && v.toString().isNotEmpty)
            .map((v) => v.toString())
            .toList();
        if (messages.isNotEmpty) return messages.join('\n');
      }

      // 2) Champ "error" (message d'erreur principal)
      if (body.containsKey('error') && body['error'] != null) {
        final error = body['error'].toString();
        if (error.isNotEmpty) return _humanizeBackendMessage(error);
      }

      // 3) Champ "message"
      if (body.containsKey('message') && body['message'] != null) {
        final message = body['message'].toString();
        if (message.isNotEmpty) return _humanizeBackendMessage(message);
      }
    }

    if (body is String && body.isNotEmpty) {
      return _humanizeBackendMessage(body);
    }

    return fallback;
  }

  /// Traduit une erreur technique du backend en message humain.
  static String _humanizeBackendMessage(String msg) {
    final lower = msg.toLowerCase();

    // Auth
    if (lower.contains('email') && (lower.contains('existe') || lower.contains('exist') || lower.contains('déjà') || lower.contains('already') || lower.contains('duplicate'))) {
      return Tr.emailAlreadyUsed.tr;
    }
    if (lower.contains('telephone') && (lower.contains('existe') || lower.contains('exist') || lower.contains('déjà') || lower.contains('already'))) {
      return Tr.phoneAlreadyUsed.tr;
    }
    if (lower.contains('mot de passe') && (lower.contains('incorrect') || lower.contains('invalid'))) {
      return Tr.wrongPassword.tr;
    }
    if (lower.contains('password') && (lower.contains('incorrect') || lower.contains('invalid') || lower.contains('wrong'))) {
      return Tr.wrongPassword.tr;
    }
    if (lower.contains('utilisateur') && (lower.contains('introuvable') || lower.contains('not found') || lower.contains('pas trouvé'))) {
      return Tr.accountNotFound.tr;
    }
    if (lower.contains('user') && lower.contains('not found')) {
      return Tr.accountNotFound.tr;
    }

    // Session
    if (lower.contains('non authentifié') || lower.contains('unauthorized') || lower.contains('401') || lower.contains('expired') || lower.contains('expiré')) {
      return Tr.sessionExpired.tr;
    }

    // RDV
    if (lower.contains('créneau') && (lower.contains('plus disponible') || lower.contains('réservé') || lower.contains('indisponible'))) {
      return Tr.slotAlreadyTaken.tr;
    }
    if (lower.contains('slot') && (lower.contains('taken') || lower.contains('unavailable') || lower.contains('booked'))) {
      return Tr.slotAlreadyTaken.tr;
    }
    if (lower.contains('annul') && (lower.contains('passé') || lower.contains('past') || lower.contains('impossible'))) {
      return Tr.cannotCancelPast.tr;
    }

    // Si le message est déjà assez clair (phrase complète), le retourner tel quel
    return msg;
  }

  /// Transforme une exception en message utilisateur précis.
  static String handleException(dynamic e) {
    if (e is SocketException) {
      return Tr.networkError.tr;
    }
    final msg = e.toString().toLowerCase();
    if (msg.contains('timeout') || msg.contains('timed out')) {
      return Tr.timeoutError.tr;
    }
    if (msg.contains('socket') || msg.contains('network') || msg.contains('connection refused') || msg.contains('no route') || msg.contains('host')) {
      return Tr.networkError.tr;
    }
    if (msg.contains('500') || msg.contains('internal server')) {
      return Tr.serverError.tr;
    }
    return Tr.connectionError.tr;
  }

  /// Valide un email et retourne null si valide, ou un message d'erreur.
  static String? validateEmail(String email) {
    if (email.trim().isEmpty) return Tr.emailRequired.tr;
    final regex = RegExp(r'^[\w\-.+]+@[\w\-]+\.[\w\-]{2,}$');
    if (!regex.hasMatch(email.trim())) return Tr.emailInvalid.tr;
    return null;
  }

  /// Valide un mot de passe.
  static String? validatePassword(String password) {
    if (password.isEmpty) return Tr.passwordRequired.tr;
    if (password.length < 6) return Tr.passwordTooShort.tr;
    return null;
  }

  /// Valide un numéro de téléphone sénégalais.
  static String? validatePhone(String phone) {
    if (phone.trim().isEmpty) return Tr.phoneRequired.tr;
    final cleaned = phone.trim().replaceAll(RegExp(r'[\s\-.]'), '');
    // Accepte : 7X XXX XX XX ou +221 7X XXX XX XX
    final regex = RegExp(r'^(\+221)?[7][0-8]\d{7}$');
    if (!regex.hasMatch(cleaned)) return Tr.phoneInvalid.tr;
    return null;
  }
}
