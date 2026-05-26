import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductPrice {
  final String id;
  final String name;
  final String sku;
  double price;
  final int stock;
  final String stockUnit;
  final String category;
  final FaIconData icon;
  final Color iconColor;

  ProductPrice({
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
    required this.stock,
    required this.stockUnit,
    required this.category,
    required this.icon,
    required this.iconColor,
  });
}