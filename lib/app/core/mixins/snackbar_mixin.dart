import 'dart:ui';
import 'package:get/get.dart';
import '../../translate/translation_keys.dart';

mixin SnackbarMixin {
  void showError(String message) {
    Get.snackbar(Tr.error.tr, message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFE53935),
      colorText: const Color(0xFFFFFFFF),
    );
  }

  void showSuccess(String title, String message) {
    Get.snackbar(title, message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF43A047),
      colorText: const Color(0xFFFFFFFF),
    );
  }
}
