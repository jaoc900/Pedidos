import 'package:pedidos/enums/taxes_status_enum.dart';

class TaxPeriod {
  final String period;
  final DateTime date;
  final double iva;
  final double isr;
  final double ieps;
  final TaxStatus status;
  final DateTime paymentDate;

  TaxPeriod({
    required this.period,
    required this.date,
    required this.iva,
    required this.isr,
    required this.ieps,
    required this.status,
    required this.paymentDate,
  });
}