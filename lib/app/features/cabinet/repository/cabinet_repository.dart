import 'package:get/get.dart';
import '../../../constante_Endpoit/api_endpoints.dart';
import '../../../core/api/api_service.dart';

class CabinetRepository {
  final ApiService _api;

  CabinetRepository(this._api);

  // GET /api/patient/cabinets
  Future<Response> getCabinets() {
    return _api.get(ApiEndpoints.cabinets);
  }
  

  // GET /api/patient/cabinets/{id}
  Future<Response> getCabinetById(int id) {
    return _api.get(ApiEndpoints.cabinetById(id));
  }


  // GET /api/patient/specialites/cabinet/{id}
  Future<Response> getSpecialitesByCabinet(int id) {
    return _api.get(ApiEndpoints.specialitesByCabinet(id));
  }
}
