import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    required this.iconName
  });
}