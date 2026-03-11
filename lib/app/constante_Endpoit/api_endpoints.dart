abstract class ApiEndpoints {
  final String baseURL = 'http://10.0.2.2:8085/api/';

  final String login = 'auth/login';
  final String register = 'auth/register';
  final String cabinets = 'patient/cabinets';
  final String specialites = 'patient/specialites';
  final String medecins = 'patient/medecins';
  final String rdv = 'patient/rdv';
  final String rdvEnAttente = 'patient/rdv/en-attente';
  final String rdvConfirmes = 'patient/rdv/confirmes';
  final String rdvHistorique = 'patient/rdv/historique';

}
