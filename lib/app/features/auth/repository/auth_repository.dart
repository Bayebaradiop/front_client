import 'package:get/get.dart';
import '../../../core/api/api_service.dart';
import '../../../constante_Endpoit/api_endpoints.dart';

class AuthRepository {
  final ApiService _api;

  AuthRepository(this._api);

  // POST /api/auth/login
  Future<Response> login(String email, String motDePasse) {
    return _api.post(
      ApiEndpoints.login,
      {'email': email, 'motDePasse': motDePasse},
    );
  }

  // POST /api/auth/register
  Future<Response> register({
    required String prenom,
    required String nom,
    required String email,
    required String telephone,
    required String motDePasse,
  }) {
    return _api.post(
      ApiEndpoints.register,
      {
        'prenom': prenom,
        'nom': nom,
        'email': email,
        'telephone': telephone,
        'motDePasse': motDePasse,
      },
    );
  }

  // POST /api/auth/logout
  Future<Response> logout() {
    return _api.post(ApiEndpoints.logout, {});
  }

  // GET /api/auth/profile
  Future<Response> getProfile() {
    return _api.get(ApiEndpoints.profile);
  }

  // PUT /api/auth/profile
  Future<Response> updateProfile(Map<String, dynamic> body) {
    return _api.put(ApiEndpoints.profile, body);
  }
}
