import 'package:get/get.dart';
import '../../../constante_Endpoit/api_endpoints.dart';
import '../../../core/api/api_service.dart';

class RendezvousRepository {
  final ApiService _api;

  RendezvousRepository(this._api);

  // GET /api/patient/rdv
  Future<Response> getRdv() {
    return _api.get(ApiEndpoints.rdv);
  }


  // GET /api/patient/rdv/en-attente
  Future<Response> getRdvEnAttente() {
    return _api.get(ApiEndpoints.rdvEnAttente);
  }


  // GET /api/patient/rdv/confirmes
  Future<Response> getRdvConfirmes() {
    return _api.get(ApiEndpoints.rdvConfirmes);
  }


  // GET /api/patient/rdv/historique
  Future<Response> getRdvHistorique() {
    return _api.get(ApiEndpoints.rdvHistorique);
  }


  // GET /api/patient/rdv/{id}
  Future<Response> getRdvById(int id) {
    return _api.get(ApiEndpoints.rdvById(id));
  }


  // POST /api/patient/rdv
  Future<Response> createRdv(Map<String, dynamic> body) {
    return _api.post(ApiEndpoints.rdv, body);
  }


  // PUT /api/patient/rdv/{id}/annuler
  Future<Response> annulerRdv(int id) {
    return _api.put(ApiEndpoints.rdvAnnuler(id), {});
  }

}
