import 'package:flutter/material.dart';

class ExpenseCategory {
  final String id;
  final String name;
  final String description;
  final Color color;
  final int expenseCount;
  final double totalSpent;
  final String iconName;

  ExpenseCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.expenseCount,
    required this.totalSpent,
    required this.iconName,
  });

  /// Convierte un JSON a un objeto ExpenseCategory
  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      color: _getColorFromJson(json['color']),
      expenseCount: json['expenseCount'] ?? 0,
      totalSpent: (json['totalSpent'] ?? 0).toDouble(),
      iconName: json['iconName'] ?? 'tag',
    );
  }

  /// Convierte un objeto ExpenseCategory a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': _colorToJson(color),
      'expenseCount': expenseCount,
      'totalSpent': totalSpent,
      'iconName': iconName,
    };
  }

  /// Convierte un string de color a Color de Flutter
  static Color _getColorFromJson(dynamic colorValue) {
    if (colorValue == null) return Colors.blue;

    // Si es un string con formato hexadecimal
    if (colorValue is String && colorValue.startsWith('#')) {
      try {
        final hex = colorValue.substring(1);
        return Color(int.parse('0xFF$hex'));
      } catch (e) {
        return Colors.blue;
      }
    }

    // Si es un número (int) como valor de color
    if (colorValue is int) {
      return Color(colorValue);
    }

    return Colors.blue;
  }

  /// Convierte un Color de Flutter a string hexadecimal
  static String _colorToJson(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }
}

/// DTO para crear/actualizar categorías
class CreateExpenseCategoryRequest {
  final String name;
  final String description;
  final String color;
  final String iconName;

  CreateExpenseCategoryRequest({
    required this.name,
    required this.description,
    required this.color,
    required this.iconName,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'color': color,
      'iconName': iconName,
    };
  }
}