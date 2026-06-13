// lib/models/employee_role_simple_model.dart
class EmployeeRoleSimple {
  final int id;
  final String name;

  EmployeeRoleSimple({
    required this.id,
    required this.name,
  });

  factory EmployeeRoleSimple.fromJson(Map<String, dynamic> json) {
    return EmployeeRoleSimple(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}