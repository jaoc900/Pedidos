import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

class ReportData {
  final String title;
  final String subtitle;
  final FaIconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  ReportData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });
}