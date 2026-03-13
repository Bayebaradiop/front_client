import 'package:get/get.dart';
import '../../../constante_Endpoit/api_endpoints.dart';
import '../../../core/api/api_service.dart';

class MedecinRepository {
  final ApiService _api;

  MedecinRepository(this._api);

  // GET /api/patient/medecins
  Future<Response> getMedecins() {
    return _api.get(ApiEndpoints.medecins);
  }
  

  // GET /api/patient/medecins?specialite_id={id}
  Future<Response> getMedecinsBySpecialite(int specialiteId) {
    return _api.get(ApiEndpoints.medecinsBySpecialite(specialiteId));
  }


  // GET /api/patient/medecins?cabinet_id={id}
  Future<Response> getMedecinsByCabinet(int cabinetId) {
    return _api.get(ApiEndpoints.medecinsByCabinet(cabinetId));
  }


  // GET /api/patient/medecins/{id}
  Future<Response> getMedecinById(int id) {
    return _api.get(ApiEndpoints.medecinById(id));
  }


  // GET /api/patient/medecins/{id}/disponibilites
  // GET /api/patient/medecins/{id}/disponibilites?date={date}
  Future<Response> getDisponibilites(int medecinId, {String? date}) {
    final endpoint = date != null
        ? ApiEndpoints.disponibilitesByDate(medecinId, date)
        : ApiEndpoints.disponibilites(medecinId);
    return _api.get(endpoint);
  }
}
