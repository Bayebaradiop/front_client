import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_colors.dart';

class AppTextStyles {
  static bool get _dark => Get.isDarkMode;

  static Color get _textPrimary =>
      _dark ? AppColors.darkTextPrimary : AppColors.textPrimary;
  static Color get _textSecondary =>
      _dark ? AppColors.darkTextSecondary : AppColors.textSecondary;
  static Color get _textLight =>
      _dark ? AppColors.darkTextLight : AppColors.textLight;

  static TextStyle get heading1 =>
      TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _textPrimary);

  static TextStyle get heading2 =>
      TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _textPrimary);

  static TextStyle get heading3 =>
      TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _textPrimary);

  static TextStyle get subtitle => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: _textSecondary,
  );

  static TextStyle get body => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: _textSecondary,
  );

  static TextStyle get bodyBold =>
      TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textPrimary);

  static TextStyle get caption =>
      TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: _textLight);

  static TextStyle get button => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );

  static TextStyle get label => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: _textSecondary,
  );
}
