import 'package:pedidos/enums/alert_type_enum.dart';
import 'package:pedidos/enums/severity_alert_enum.dart';

class Alert {
  final String id;
  final String title;
  final String description;
  final AlertType type;
  final Severity severity;
  final DateTime date;
  bool isRead;
  final String? actionText;

  Alert({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.severity,
    required this.date,
    required this.isRead,
    this.actionText,
  });
}