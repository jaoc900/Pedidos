import 'package:pedidos/enums/payment_status_enum.dart';

class PaymentEvent {
  final String id;
  final String title;
  final double amount;
  final DateTime dueDate;
  final PaymentStatus status;
  final String client;

  PaymentEvent({
    required this.id,
    required this.title,
    required this.amount,
    required this.dueDate,
    required this.status,
    required this.client,
  });
}