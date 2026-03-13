import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../models/auth_model.dart';
import '../../../translate/translation_keys.dart';
import '../repository/auth_repository.dart';
import '../../../core/api/api_service.dart';

class AuthViewModel extends GetxController {
  final AuthRepository _repo;

  AuthViewModel(this._repo);

  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final Rxn<AuthModel> currentUser = Rxn<AuthModel>();

  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _loadSavedUser();
  }

  void _loadSavedUser() {
    final userData = _storage.read('user');
    if (userData != null) {
      currentUser.value = AuthModel.fromJson(Map<String, dynamic>.from(userData));
      isLoggedIn.value = true;
    }
  }


  Future<String?> login(String email, String motDePasse) async {
    isLoading.value = true;
    try {
      final response = await _repo.login(email, motDePasse);
      if (response.statusCode == 200) {
        final user = AuthModel.fromJson(response.body['user']);
        currentUser.value = user;
        _storage.write('user', user.toJson());

        if (kIsWeb && response.body['token'] != null) {
          _storage.write('jwt_cookie', 'access_token=${response.body['token']}');
        }

        isLoggedIn.value = true;
        return null;

      } else {
        return response.body?['error'] ?? response.body?['message'] ?? Tr.loginFailed.tr;
      }
    } catch (e) {
      return Tr.connectionError.tr;
    } finally {
      isLoading.value = false;
    }
  }


  Future<String?> register({
    required String prenom,
    required String nom,
    required String email,
    required String telephone,
    required String motDePasse,
  }) async {
    isLoading.value = true;
    try {
      final response = await _repo.register(
        prenom: prenom,
        nom: nom,
        email: email,
        telephone: telephone,
        motDePasse: motDePasse,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return null;
      } else {
        return response.body?['error'] ?? response.body?['message'] ?? Tr.registerError.tr;
      }
    } catch (e) {
      return Tr.connectionError.tr;
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> logout() async {
    try {
      await _repo.logout();
    } catch (_) {}
    Get.find<ApiService>().clearToken();
    _storage.remove('user');
    currentUser.value = null;
    isLoggedIn.value = false;
  }

  Future<String?> fetchProfile() async {
    isLoading.value = true;
    try {
      final response = await _repo.getProfile();
      if (response.statusCode == 200) {
        final user = AuthModel.fromJson(response.body);
        currentUser.value = user;
        _storage.write('user', user.toJson());
        return null;
      } else {
        return response.body?['error'] ?? response.body?['message'] ?? Tr.loadingError.tr;
      }
    } catch (e) {
      return Tr.connectionError.tr;
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> updateProfile({
    required String prenom,
    required String nom,
    required String telephone,
  }) async {
    isLoading.value = true;
    try {
      final response = await _repo.updateProfile({
        'prenom': prenom,
        'nom': nom,
        'telephone': telephone,
      });
      debugPrint('[updateProfile] status=${response.statusCode} body=${response.body}');
      if (response.statusCode == 200) {
        final user = AuthModel.fromJson(response.body);
        currentUser.value = user;
        _storage.write('user', user.toJson());
        return null;
      } else {
        return response.body?['error'] ?? response.body?['message'] ?? Tr.profileUpdateError.tr;
      }
    } catch (e) {
      debugPrint('[updateProfile] error=$e');
      return Tr.connectionError.tr;
    } finally {
      isLoading.value = false;
    }
  }
}
