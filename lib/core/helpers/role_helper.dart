// lib/core/helpers/role_helper.dart
import 'package:pedidos/services/user_preferences.dart';
import 'package:pedidos/enums/user_role_enum.dart';

class RoleHelper {
  static Future<UserRole> getCurrentUserRole() async {
    final userPrefs = UserPreferences();
    await userPrefs.init();
    final role = userPrefs.getUserRole();

    switch (role) {
      case 4:
        return UserRole.admin;
      case 3:
        return UserRole.accountant;
      case 2:
        return UserRole.warehouse;
      case 1:
        return UserRole.seller;
      default:
        return UserRole.seller;
    }
  }

  static Future<bool> isAdmin() async {
    final userPrefs = UserPreferences();
    await userPrefs.init();
    return userPrefs.isAdmin();
  }

  static Future<int?> getUserRoleValue() async {
    final userPrefs = UserPreferences();
    await userPrefs.init();
    return userPrefs.getUserRole();
  }
}