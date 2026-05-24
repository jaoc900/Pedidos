import 'package:pedidos/enums/invoice_status_enum.dart';

class Invoice {
  final String id;
  final String number;
  final String client;
  final String clientId;
  final DateTime issueDate;
  final DateTime dueDate;
  final double amount;
  final double tax;
  final double total;
  InvoiceStatus status;
  final int items;
  final String category; // ← Campo agregado
  DateTime? paymentDate;
  String? paymentMethod;

  Invoice({
    required this.id,
    required this.number,
    required this.client,
    required this.clientId,
    required this.issueDate,
    required this.dueDate,
    required this.amount,
    required this.tax,
    required this.total,
    required this.status,
    required this.items,
    required this.category, // ← Nuevo parámetro requerido
    this.paymentDate,
    this.paymentMethod,
  });
}