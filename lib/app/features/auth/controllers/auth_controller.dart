import 'dart:ui';
import 'package:get/get.dart';
import '../../../translate/translation_keys.dart';

class AuthController extends GetxController {
  final emailController = ''.obs;
  final passwordController = ''.obs;
  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final userName = 'Fatou'.obs;

  // Register fields
  final prenomRegister = ''.obs;
  final nomRegister = ''.obs;
  final emailRegister = ''.obs;
  final telephoneRegister = ''.obs;
  final passwordRegister = ''.obs;
  final confirmPasswordRegister = ''.obs;

  void login() {
    if (emailController.value.isEmpty || passwordController.value.isEmpty) {
      Get.snackbar(
        Tr.error.tr,
        Tr.fillAllFields.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFFFFFF),
      );
      return;
    }
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      isLoggedIn.value = true;
      Get.offAllNamed('/home');
      Get.snackbar(
        Tr.welcome.tr,
        Tr.loginSuccess.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF43A047),
        colorText: const Color(0xFFFFFFFF),
      );
    });
  }

  void logout() {
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }

  void registerUser() {
    if (prenomRegister.value.isEmpty ||
        nomRegister.value.isEmpty ||
        emailRegister.value.isEmpty ||
        telephoneRegister.value.isEmpty ||
        passwordRegister.value.isEmpty ||
        confirmPasswordRegister.value.isEmpty) {
      Get.snackbar(
        Tr.error.tr,
        Tr.fillAllFields.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFFFFFF),
      );
      return;
    }
    if (passwordRegister.value != confirmPasswordRegister.value) {
      Get.snackbar(
        Tr.error.tr,
        Tr.passwordMismatch.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFFFFFF),
      );
      return;
    }
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      Get.offAllNamed('/login');
      Get.snackbar(
        Tr.registerSuccess.tr,
        Tr.loginSuccess.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF43A047),
        colorText: const Color(0xFFFFFFFF),
      );
    });
  }
}
