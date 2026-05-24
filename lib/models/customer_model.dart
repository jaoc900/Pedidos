import 'package:pedidos/enums/customer_type_enum.dart';

class Customer {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final CustomerType type;
  final bool isActive;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.type,
    required this.isActive,
  });
}