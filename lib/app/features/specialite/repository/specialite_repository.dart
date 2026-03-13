import 'package:get/get.dart';
import '../../../core/api/api_service.dart';
import '../../../constante_Endpoit/api_endpoints.dart';

class SpecialiteRepository {
  final ApiService _api;
  SpecialiteRepository(this._api);

  Future<Response> getSpecialites() => _api.get(ApiEndpoints.specialites);
}
