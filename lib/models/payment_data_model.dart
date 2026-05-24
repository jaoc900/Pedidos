import 'package:pedidos/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaymentData {
  final String id;
  final String client;
  final String date;
  final double amount;
  final String status;
  final String method;
  final bool isPending;
  final Color statusColor;
  final Color statusBgColor;
  final FaIconData icon;

  PaymentData({
    required this.id,
    required this.client,
    required this.date,
    required this.amount,
    required this.status,
    required this.method,
    required this.isPending,
    required this.statusColor,
    required this.statusBgColor,
    required this.icon,
  });

  // Constructor para pagos simples (desde lista)
  PaymentData.simple({
    required this.id,
    required this.client,
    required this.date,
    required this.amount,
    required this.status,
    required this.isPending,
  }) : method = '',
        statusColor = isPending ? AppTheme.warning : AppTheme.secondary,
        statusBgColor = isPending
            ? AppTheme.warningContainer.withValues(alpha: 0.2)
            : AppTheme.secondaryContainer.withValues(alpha: 0.2),
        icon = isPending ? FontAwesomeIcons.clock : FontAwesomeIcons.circleCheck;

  // Constructor para pagos con método (desde historial)
  PaymentData.withMethod({
    required this.id,
    required this.client,
    required this.date,
    required this.amount,
    required this.status,
    required this.method,
    required this.isPending,
    required this.statusColor,
    required this.statusBgColor,
    required this.icon,
  });

  // Constructor para pagos pendientes
  PaymentData.pending({
    required this.id,
    required this.client,
    required this.date,
    required this.amount,
    required this.method,
  }) : status = 'Pendiente',
        isPending = true,
        statusColor = AppTheme.warning,
        statusBgColor = AppTheme.warningContainer.withValues(alpha: 0.2),
        icon = FontAwesomeIcons.clock;

  // Constructor para pagos completados
  PaymentData.completed({
    required this.id,
    required this.client,
    required this.date,
    required this.amount,
    required this.method,
  }) : status = 'Completado',
        isPending = false,
        statusColor = AppTheme.secondary,
        statusBgColor = AppTheme.secondaryContainer.withValues(alpha: 0.2),
        icon = FontAwesomeIcons.circleCheck;

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    final isPending = json['status'] == 'Pendiente';
    return PaymentData(
      id: json['id'],
      client: json['client'],
      date: json['date'],
      amount: json['amount'].toDouble(),
      status: json['status'],
      method: json['method'] ?? '',
      isPending: isPending,
      statusColor: isPending ? AppTheme.warning : AppTheme.secondary,
      statusBgColor: isPending
          ? AppTheme.warningContainer.withValues(alpha: 0.2)
          : AppTheme.secondaryContainer.withValues(alpha: 0.2),
      icon: isPending ? FontAwesomeIcons.clock : FontAwesomeIcons.circleCheck,
    );
  }

  String get formattedAmount => '\$${amount.toStringAsFixed(2)}';
}