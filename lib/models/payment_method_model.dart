import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:pedidos/theme/theme.dart';

class PaymentMethod {
  final int id;
  final String name;
  final String? icon;
  final String? color;
  final bool isActive;

  PaymentMethod({
    required this.id,
    required this.name,
    this.icon,
    this.color,
    required this.isActive,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      icon: json['icon'],
      color: json['color'],
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
      'isActive': isActive,
    };
  }

  // Método helper para obtener el FaIconData basado en el nombre del icono
  FaIconData get faIcon {
    switch (icon) {
      case 'moneyBill':
        return FontAwesomeIcons.moneyBill;
      case 'buildingColumns':
        return FontAwesomeIcons.buildingColumns;
      case 'qrcode':
        return FontAwesomeIcons.qrcode;
      case 'creditCard':
        return FontAwesomeIcons.creditCard;
      case 'paypal':
        return FontAwesomeIcons.paypal;
      case 'bank':
        return FontAwesomeIcons.bank;
      case 'mobile':
        return FontAwesomeIcons.mobile;
      case 'coins':
        return FontAwesomeIcons.coins;
      case 'wallet':
        return FontAwesomeIcons.wallet;
      case 'applePay':
        return FontAwesomeIcons.applePay;
      case 'googlePay':
        return FontAwesomeIcons.googlePay;
      default:
        return FontAwesomeIcons.creditCard;
    }
  }

  // Método helper para obtener el color como Color de Flutter
  Color get colorValue {
    if (color != null && color!.startsWith('#') && color!.length == 7) {
      try {
        final hexColor = color!.substring(1);
        return Color(int.parse('0xFF$hexColor'));
      } catch (e) {
        return AppTheme.primary;
      }
    }
    return AppTheme.primary;
  }

  // Método helper para obtener el estado como texto
  String get statusText {
    return isActive ? 'Activo' : 'Inactivo';
  }

  // Método helper para obtener el color del estado
  Color get statusColor {
    return isActive ? AppTheme.secondary : AppTheme.error;
  }

  // Método helper para obtener el color de fondo del estado
  Color get statusBgColor {
    return isActive ? AppTheme.secondaryContainer : AppTheme.errorContainer;
  }
}

// DTO para crear/actualizar métodos de pago
class CreatePaymentMethodRequest {
  final String name;
  final String? icon;
  final String? color;
  final bool isActive;

  CreatePaymentMethodRequest({
    required this.name,
    this.icon,
    this.color,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
      'color': color,
      'isActive': isActive,
    };
  }
}