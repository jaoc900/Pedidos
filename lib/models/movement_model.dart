import 'package:pedidos/enums/movement_enum.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

class MovementData {
  final String title;
  final String description;
  final String amount;
  final MovementType type;
  final FaIconData icon;
  final Color iconBgColor;
  final Color iconColor;

  MovementData({
    required this.title,
    required this.description,
    required this.amount,
    required this.type,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
  });
}