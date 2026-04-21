import 'dart:ui';
import 'package:flutter/material.dart' show EdgeInsets, Icon, Icons;
import 'package:get/get.dart';
import '../../translate/translation_keys.dart';
import '../../theme/app_colors.dart';

mixin SnackbarMixin {
  void showError(String message) {
    Get.snackbar(Tr.error.tr, message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.error,
      colorText: const Color(0xFFFFFFFF),
      icon: const Icon(Icons.error_outline, color: Color(0xFFFFFFFF), size: 28),
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      borderRadius: 12,
      maxWidth: 500,
    );
  }

  void showSuccess(String title, String message) {
    Get.snackbar(title, message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primary,
      colorText: const Color(0xFFFFFFFF),
      icon: const Icon(Icons.check_circle_outline, color: Color(0xFFFFFFFF), size: 28),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      borderRadius: 12,
      maxWidth: 500,
    );
  }
}
