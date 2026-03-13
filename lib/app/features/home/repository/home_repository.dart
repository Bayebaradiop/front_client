import 'package:get/get.dart';
import '../../../constante_Endpoit/api_endpoints.dart';
import '../../../core/api/api_service.dart';

class HomeRepository {
  final ApiService _api;

  HomeRepository(this._api);

  // GET /api/patient/cabinets
  Future<Response> getCabinets() {
    return _api.get(ApiEndpoints.cabinets);
  }

  // GET /api/patient/specialites
  Future<Response> getSpecialites() {
    return _api.get(ApiEndpoints.specialites);
  }

  // GET /api/patient/rdv/confirmes
  Future<Response> getRdvConfirmes() {
    return _api.get(ApiEndpoints.rdvConfirmes);
  }
}
