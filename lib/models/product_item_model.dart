import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/enums/stock_status_enum.dart';
import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final int stock;
  final StockStatus stockStatus;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.stock,
    required this.stockStatus,
    required this.imageUrl,
  });

  // Getters útiles
  bool get isInStock => stockStatus == StockStatus.inStock;
  bool get isLowStock => stockStatus == StockStatus.lowStock;
  bool get isCritical => stockStatus == StockStatus.critical;

  String get stockStatusText {
    switch (stockStatus) {
      case StockStatus.inStock:
        return 'En stock';
      case StockStatus.lowStock:
        return 'Stock bajo';
      case StockStatus.critical:
        return 'Crítico';
    }
  }

  Color get stockStatusColor {
    switch (stockStatus) {
      case StockStatus.inStock:
        return AppTheme.secondary;
      case StockStatus.lowStock:
        return AppTheme.warning;
      case StockStatus.critical:
        return AppTheme.error;
    }
  }

  // Método de fábrica para crear copias modificadas
  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? category,
    int? stock,
    StockStatus? stockStatus,
    String? imageUrl,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      stockStatus: stockStatus ?? this.stockStatus,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // Método para calcular valor total del inventario
  double get totalInventoryValue => price * stock;

  // Formato de precio
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
}
