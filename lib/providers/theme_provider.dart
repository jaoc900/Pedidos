// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _keyDarkMode = 'dark_mode';

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _loadTheme();
  }

  // Cargar tema desde SharedPreferences
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_keyDarkMode) ?? false;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    } catch (e) {
      print('Error cargando tema: $e');
    }
  }

  // Cambiar tema
  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    // Guardar en SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyDarkMode, isDark);
    } catch (e) {
      print('Error guardando tema: $e');
    }

    notifyListeners();
  }

  // Cambiar tema sin parámetro (toggle)
  Future<void> toggle() async {
    final isDark = !isDarkMode;
    await toggleTheme(isDark);
  }

  // Obtener el tema actual como bool
  bool getDarkMode() {
    return isDarkMode;
  }
}