import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
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

  // POST /api/auth/forgot-password
  Future<Response> forgotPassword(String email) {
    return _api.post(ApiEndpoints.forgotPassword, {'email': email});
  }

  // POST /api/auth/reset-password
  Future<Response> resetPassword(String email, String code, String newPassword) {
    return _api.post(ApiEndpoints.resetPassword, {
      'email': email,
      'code': code,
      'newPassword': newPassword,
    });
  }

  // PUT /api/auth/profile/photo (multipart)
  Future<Map<String, dynamic>> uploadProfilePhoto(File imageFile) async {
    final uri = Uri.parse('${ApiEndpoints.baseURL}${ApiEndpoints.profilePhoto}');
    final request = http.MultipartRequest('PUT', uri);

    // Auth header
    final storage = GetStorage();
    final token = storage.read('jwt_cookie');
    if (token != null) {
      if (kIsWeb) {
        final value = token.startsWith('access_token=')
            ? token.substring('access_token='.length)
            : token;
        request.headers['Authorization'] = 'Bearer $value';
      } else {
        request.headers['Cookie'] = token;
      }
    }

    request.files.add(
      await http.MultipartFile.fromPath('photo', imageFile.path),
    );

    debugPrint('[uploadProfilePhoto] URI=$uri token=${token != null ? "present" : "MISSING"}');

    final streamed = await request.send();
    final responseBody = await streamed.stream.bytesToString();
    debugPrint('[uploadProfilePhoto] statusCode=${streamed.statusCode} body=$responseBody');

    // Store new cookie if returned
    final setCookie = streamed.headers['set-cookie'];
    if (setCookie != null) {
      final cookieValue = setCookie.split(';').first.trim();
      storage.write('jwt_cookie', cookieValue);
    }

    return {
      'statusCode': streamed.statusCode,
      'body': responseBody.isNotEmpty ? jsonDecode(responseBody) : <String, dynamic>{},
    };
  }
}
