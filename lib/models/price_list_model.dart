import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/enums/price_list_enum.dart';

class PriceList {
  final String id;
  final String name;
  final String description;
  final FaIconData icon;
  final Color iconColor;
  final Color borderColor;
  final PriceListStatus status;
  final int items;
  final double margin;

  PriceList({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.borderColor,
    required this.status,
    required this.items,
    required this.margin,
  });
}