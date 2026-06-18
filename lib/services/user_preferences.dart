import 'package:shared_preferences/shared_preferences.dart';
import 'package:pedidos/models/Response/login_response.dart';
import 'package:flutter/material.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._internal();
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  // Keys para SharedPreferences
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyTokenExpiry = 'token_expiry';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserFirstName = 'user_first_name';
  static const String _keyUserLastName = 'user_last_name';
  static const String _keyUserRole = 'user_role';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyRememberMe = 'remember_me';
  static const String _keySavedEmail = 'saved_email';

  // ==================== NUEVAS KEYS PARA PREFERENCIAS ====================
  static const String _keyDarkMode = 'dark_mode';
  static const String _keySendSms = 'send_sms';
  static const String _keySendPush = 'send_push';

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  // Inicializar SharedPreferences
  Future<void> init() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
      debugPrint('✅ UserPreferences inicializado');
    }
  }

  // Verificar si está inicializado
  void _checkInitialized() {
    if (!_isInitialized) {
      throw Exception('UserPreferences no inicializado. Llama a init() primero.');
    }
  }

  // ==================== TOKEN METHODS ====================

  Future<void> saveToken(String token) async {
    _checkInitialized();
    await _prefs.setString(_keyAccessToken, token);
    debugPrint('✅ Token guardado');
  }

  String? getToken() {
    _checkInitialized();
    return _prefs.getString(_keyAccessToken);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    _checkInitialized();
    await _prefs.setString(_keyRefreshToken, refreshToken);
  }

  String? getRefreshToken() {
    _checkInitialized();
    return _prefs.getString(_keyRefreshToken);
  }

  Future<void> saveTokenExpiry(String expiry) async {
    _checkInitialized();
    await _prefs.setString(_keyTokenExpiry, expiry);
  }

  DateTime? getTokenExpiry() {
    _checkInitialized();
    final expiryStr = _prefs.getString(_keyTokenExpiry);
    if (expiryStr != null) {
      return DateTime.parse(expiryStr);
    }
    return null;
  }

  bool isTokenValid() {
    _checkInitialized();
    final expiry = getTokenExpiry();
    if (expiry == null) return false;
    return DateTime.now().isBefore(expiry);
  }

  bool isTokenExpiringSoon({int minutes = 5}) {
    _checkInitialized();
    final expiry = getTokenExpiry();
    if (expiry == null) return true;
    final timeUntilExpiry = expiry.difference(DateTime.now());
    return timeUntilExpiry.inMinutes <= minutes;
  }

  // ==================== USER INFO METHODS ====================

  Future<void> saveUserInfo(UserData user) async {
    _checkInitialized();
    await _prefs.setString(_keyUserId, user.id.toString());
    await _prefs.setString(_keyUserEmail, user.email);
    await _prefs.setString(_keyUserFirstName, user.firstName);
    await _prefs.setString(_keyUserLastName, user.lastName);
    await _prefs.setInt(_keyUserRole, user.role);
    await _prefs.setBool(_keyIsLoggedIn, true);

    // También guardar token si viene en el usuario
    if (user.token.isNotEmpty) {
      await saveToken(user.token);
    }
    if (user.refreshToken.isNotEmpty) {
      await saveRefreshToken(user.refreshToken);
    }
    if (user.expiresAt != null) {
      await saveTokenExpiry(user.expiresAt.toIso8601String());
    }

    debugPrint('✅ Información de usuario guardada: ${user.fullName}');
  }

  Map<String, dynamic> getUserInfo() {
    _checkInitialized();
    return {
      'id': _prefs.getString(_keyUserId),
      'email': _prefs.getString(_keyUserEmail),
      'firstName': _prefs.getString(_keyUserFirstName),
      'lastName': _prefs.getString(_keyUserLastName),
      'role': _prefs.getInt(_keyUserRole),
      'isLoggedIn': _prefs.getBool(_keyIsLoggedIn) ?? false,
    };
  }

  String? getUserId() {
    _checkInitialized();
    return _prefs.getString(_keyUserId);
  }

  String? getUserEmail() {
    _checkInitialized();
    return _prefs.getString(_keyUserEmail);
  }

  String? getUserFirstName() {
    _checkInitialized();
    return _prefs.getString(_keyUserFirstName);
  }

  String? getUserLastName() {
    _checkInitialized();
    return _prefs.getString(_keyUserLastName);
  }

  String getFullName() {
    _checkInitialized();
    final firstName = getUserFirstName() ?? '';
    final lastName = getUserLastName() ?? '';
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '$firstName $lastName';
    }
    return firstName.isNotEmpty ? firstName : lastName;
  }

  int? getUserRole() {
    _checkInitialized();
    return _prefs.getInt(_keyUserRole);
  }

  bool isAdmin() {
    _checkInitialized();
    return getUserRole() == 4;
  }

  bool isLoggedIn() {
    _checkInitialized();
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // ==================== REMEMBER ME METHODS ====================

  Future<void> saveRememberMe(bool rememberMe, {String? email}) async {
    _checkInitialized();
    await _prefs.setBool(_keyRememberMe, rememberMe);
    if (rememberMe && email != null) {
      await _prefs.setString(_keySavedEmail, email);
      debugPrint('✅ Recordar dispositivo activado para: $email');
    } else if (!rememberMe) {
      await _prefs.remove(_keySavedEmail);
      debugPrint('🗑️ Recordar dispositivo desactivado');
    }
  }

  bool getRememberMe() {
    _checkInitialized();
    return _prefs.getBool(_keyRememberMe) ?? false;
  }

  String? getSavedEmail() {
    _checkInitialized();
    return _prefs.getString(_keySavedEmail);
  }

  // ==================== DARK MODE METHODS ====================

  /// Guardar preferencia de modo oscuro
  Future<void> saveDarkMode(bool isDark) async {
    _checkInitialized();
    await _prefs.setBool(_keyDarkMode, isDark);
    debugPrint('✅ Modo oscuro guardado: $isDark');
  }

  /// Obtener preferencia de modo oscuro
  bool getDarkMode() {
    _checkInitialized();
    return _prefs.getBool(_keyDarkMode) ?? false;
  }

  // ==================== RESET PREFERENCES ====================

  /// Restablecer todas las preferencias a valores por defecto
  Future<void> resetPreferences() async {
    _checkInitialized();
    await _prefs.setBool(_keyDarkMode, false);
    await _prefs.setBool(_keySendSms, false);
    await _prefs.setBool(_keySendPush, true);
    debugPrint('✅ Preferencias restablecidas a valores por defecto');
  }

  // ==================== LOGOUT METHODS ====================

  Future<void> logout() async {
    _checkInitialized();
    await _prefs.remove(_keyAccessToken);
    await _prefs.remove(_keyRefreshToken);
    await _prefs.remove(_keyTokenExpiry);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserFirstName);
    await _prefs.remove(_keyUserLastName);
    await _prefs.remove(_keyUserRole);
    await _prefs.setBool(_keyIsLoggedIn, false);

    // Mantener RememberMe si quieres, o limpiarlo
    // await _prefs.remove(_keyRememberMe);
    // await _prefs.remove(_keySavedEmail);

    debugPrint('✅ Usuario desconectado, datos limpiados');
  }

  // Limpiar todos los datos (logout completo)
  Future<void> clearAll() async {
    _checkInitialized();
    await _prefs.clear();
    debugPrint('🗑️ Todos los datos fueron limpiados');
  }

  // ==================== UTILITY METHODS ====================

  void debugPrintUserInfo() {
    _checkInitialized();
    debugPrint('========== USER INFO ==========');
    debugPrint('ID: ${getUserId()}');
    debugPrint('Nombre: ${getFullName()}');
    debugPrint('Email: ${getUserEmail()}');
    debugPrint('Rol: ${getUserRole()}');
    debugPrint('Es Admin: ${isAdmin()}');
    debugPrint('Logged In: ${isLoggedIn()}');
    debugPrint('Remember Me: ${getRememberMe()}');
    debugPrint('Token Válido: ${isTokenValid()}');
    debugPrint('Dark Mode: ${getDarkMode()}');
    debugPrint('===============================');
  }
}