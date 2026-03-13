import 'package:flutter/foundation.dart' show kIsWeb;

abstract class ApiEndpoints {
  static String get baseURL =>
      kIsWeb ? 'http://localhost:8085/api/' : 'http://172.20.10.13:8085/api/';

  // ── Auth ─────────────────────────────────────────────────────────────────
  static const String login = 'auth/login';
  static const String register = 'auth/register';
  static const String logout = 'auth/logout';
  static const String profile = 'auth/profile';           
  static const String forgotPassword = 'auth/forgot-password';
  static const String resetPassword = 'auth/reset-password';   


  // ── Cabinets ──────────────────────────────────────────────────────────────
  static const String cabinets = 'patient/cabinets';
  static String cabinetById(int id) => 'patient/cabinets/$id';


  // ── Spécialités ───────────────────────────────────────────────────────────
  static const String specialites = 'patient/specialites';
  static String specialitesByCabinet(int id) =>'patient/specialites/cabinet/$id';


  // ── Médecins ──────────────────────────────────────────────────────────────
  static const String medecins = 'patient/medecins';
  static String medecinById(int id) => 'patient/medecins/$id';
  static String medecinsBySpecialite(int specialiteId) =>'patient/medecins?specialite_id=$specialiteId';
  static String medecinsByCabinet(int cabinetId) =>'patient/medecins?cabinet_id=$cabinetId';


  // ── Disponibilités ────────────────────────────────────────────────────────
  static String disponibilites(int medecinId) =>'patient/medecins/$medecinId/disponibilites';
  static String disponibilitesByDate(int medecinId, String date) =>'patient/medecins/$medecinId/disponibilites?date=$date';


  // ── Rendez-vous ───────────────────────────────────────────────────────────
  static const String rdv = 'patient/rdv';              
  static const String rdvEnAttente = 'patient/rdv/en-attente';
  static const String rdvConfirmes = 'patient/rdv/confirmes';
  static const String rdvHistorique = 'patient/rdv/historique';
  static String rdvById(int id) => 'patient/rdv/$id';
  static String rdvAnnuler(int id) => 'patient/rdv/$id/annuler'; // PUT

}
