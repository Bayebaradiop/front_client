import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage();
  final _key = 'is_dark_mode';

  bool get isDarkMode => _storage.read(_key) ?? false;

  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    final newValue = !isDarkMode;
    _storage.write(_key, newValue);
    Get.changeThemeMode(newValue ? ThemeMode.dark : ThemeMode.light);
  }
}
