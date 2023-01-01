import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  // Enum to represent the three modes
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  // Method to change the theme mode
  void changeThemeMode(ThemeMode newThemeMode) async {
    themeMode.value = newThemeMode;
    // Save the preference
    // (You may use shared preferences or any other storage mechanism)
    // Here, we're using GetStorage for simplicity
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setString("themeMode", newThemeMode.toString());
    // GetStorage().write('themeMode', newThemeMode.toString());
  }

  _init() async {
    final _prefs = await SharedPreferences.getInstance();
    int? currThemeMode = int.parse(_prefs.getString("themeMode") ?? "0");
    ThemeMode storedThemeMode =
        ThemeMode.values[currThemeMode ?? ThemeMode.system.index];
    themeMode.value = storedThemeMode;
  }

  @override
  void onInit() {
    super.onInit();
    // Retrieve the stored theme mode preference
  }
}
