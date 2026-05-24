import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

class BudgetCategory {
  final String name;
  final double budgeted;
  final double actual;
  final FaIconData icon;
  final Color color;

  BudgetCategory({
    required this.name,
    required this.budgeted,
    required this.actual,
    required this.icon,
    required this.color,
  });
}