import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpenseData {
  final String title;
  final String category;
  final String date;
  final double amount;
  final FaIconData icon;

  ExpenseData({
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    required this.icon,
  });
}

