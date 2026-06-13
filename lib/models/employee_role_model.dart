import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/theme/theme.dart';

class EmployeeRole {
  final int id;
  final String name;
  final String description;
  final String icon;
  final String color;
  final int? parentUserId;

  EmployeeRole({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.parentUserId,
  });

  // Propiedades calculadas
  FaIconData get faIcon {
    switch (icon) {
      case 'admin':
        return FontAwesomeIcons.userShield;
      case 'seller':
        return FontAwesomeIcons.userTie;
      case 'supervisor':
        return FontAwesomeIcons.userCheck;
      case 'warehouse':
        return FontAwesomeIcons.box;
      case 'accountant':
        return FontAwesomeIcons.calculator;
      case 'manager':
        return FontAwesomeIcons.userGear;
      case 'cashier':
        return FontAwesomeIcons.moneyBill;
      case 'delivery':
        return FontAwesomeIcons.truck;
      default:
        return FontAwesomeIcons.user;
    }
  }

  Color get colorValue {
    try {
      if (color.startsWith('#')) {
        return Color(int.parse('0xFF${color.substring(1)}'));
      }
      return AppTheme.primary;
    } catch (e) {
      return AppTheme.primary;
    }
  }

  factory EmployeeRole.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data;
    if (json.containsKey('data') && json['data'] != null) {
      data = json['data'] as Map<String, dynamic>;
    } else {
      data = json;
    }

    return EmployeeRole(
      id: data['id'] ?? 0,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      icon: data['icon'] ?? 'user',
      color: data['color'] ?? '#4CAF50',
      parentUserId: data['parentUserId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'parentUserId': parentUserId,
    };
  }
}

// DTO para crear/actualizar rol
class CreateEmployeeRoleRequest {
  final String name;
  final String description;
  final String icon;
  final String color;

  CreateEmployeeRoleRequest({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
    };
  }
}