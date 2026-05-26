import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedidos/enums/payment_method_enum.dart';

class PaymentMethod {
  final String id;
  final String name;
  final String description;
  final FaIconData icon;
  PaymentMethodStatus status;
  final String details;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.status,
    required this.details,
  });
}