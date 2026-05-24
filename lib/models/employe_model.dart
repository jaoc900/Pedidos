import 'package:pedidos/enums/employee_status_enum.dart';

class Employee {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String department;
  EmployeeStatus status;
  final DateTime joinDate;
  final DateTime lastActive;
  final String avatarUrl;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.department,
    required this.status,
    required this.joinDate,
    required this.lastActive,
    required this.avatarUrl,
  });
}
