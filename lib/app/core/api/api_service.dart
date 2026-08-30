import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../constante_Endpoit/api_endpoints.dart';
import '../../routes/app_routes.dart';

class ApiService extends GetConnect {
  final _storage = GetStorage();
  bool _isRedirecting = false;

  @override
  void onInit() {
    httpClient.baseUrl = ApiEndpoints.baseURL;
    httpClient.timeout = const Duration(seconds: 10);

    httpClient.addRequestModifier<dynamic>((request) {
      final token = _storage.read('jwt_cookie');
      if (token != null) {
        // Sur web : Bearer (Cookie header bloqué par le navigateur)
        // Sur mobile : Cookie header
        if (kIsWeb) {
          final value = token.startsWith('access_token=')
              ? token.substring('access_token='.length)
              : token;
          request.headers['Authorization'] = 'Bearer $value';
        } else {
          request.headers['Cookie'] = token;
        }
      }
      return request;
    });

    httpClient.addResponseModifier((request, response) {
      final setCookie = response.headers?['set-cookie'];
      if (setCookie != null) {
        final cookieValue = setCookie.split(';').first.trim();
        _storage.write('jwt_cookie', cookieValue);
      }

      // Détection de l'expiration du Token (401 Unauthorized)
      if (response.statusCode == 401) {
        _handleUnauthorized();
      }

      return response;
    });

    super.onInit();
  }

  void _handleUnauthorized() {
    clearToken();
    _storage.remove('user');

    if (!_isRedirecting &&
        Get.currentRoute != AppRoutes.login &&
        Get.currentRoute != AppRoutes.doctorIntro &&
        Get.currentRoute != AppRoutes.splash) {
      _isRedirecting = true;
      Get.offAllNamed(AppRoutes.login);
      Get.snackbar(
        'Session expirée',
        'Votre session a expiré. Veuillez vous reconnecter.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 4),
      );
      Future.delayed(const Duration(seconds: 2), () {
        _isRedirecting = false;
      });
    }
  }

  void clearToken() {
    _storage.remove('jwt_cookie');
  }

  bool get hasToken => _storage.read('jwt_cookie') != null;
}
