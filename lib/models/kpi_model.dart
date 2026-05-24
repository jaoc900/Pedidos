import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class KPIData {
  final String title;
  final String value;
  final String? unit;
  final Color color;
  final FaIconData? icon;
  final String? subtitle;
  final double? progress;

  KPIData({
    required this.title,
    required this.value,
    this.unit,
    required this.color,
    this.icon,
    this.subtitle,
    this.progress,
  });

  // Constructor para KPI simple (primera versión)
  KPIData.simple({
    required this.title,
    required this.value,
    required this.color,
  }) : unit = null,
        icon = null,
        subtitle = null,
        progress = null;

  // Constructor para KPI con ícono (segunda versión)
  KPIData.withIcon({
    required this.title,
    required this.value,
    required this.unit,
    required this.color,
    required this.icon,
    this.subtitle,
    this.progress,
  });

  // Constructor para KPI con progreso
  KPIData.withProgress({
    required this.title,
    required this.value,
    required this.unit,
    required this.color,
    required this.icon,
    required this.progress,
    this.subtitle,
  });

  String get displayValue => unit != null ? '$value $unit' : value;

  double get progressValue => progress?.clamp(0.0, 1.0) ?? 0.0;
}
