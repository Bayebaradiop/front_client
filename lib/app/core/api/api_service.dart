import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../constante_Endpoit/api_endpoints.dart';

class ApiService extends GetConnect {
  final _storage = GetStorage();

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
      return response;
    });

    super.onInit();
  }

  void clearToken() {
    _storage.remove('jwt_cookie');
  }

  bool get hasToken => _storage.read('jwt_cookie') != null;
}
