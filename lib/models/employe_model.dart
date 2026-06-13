// models/employee_model.dart
import 'package:pedidos/enums/employee_status_enum.dart';

class Employee {
  final int id;
  final String firstName;
  final String? middleName;
  final String paternalSurname;
  final String maternalSurname;
  final String phone;
  final int userId;
  final String userEmail;
  final String userRole;
  final double salary;
  final DateTime createdAt;
  final int roleId;
  final int? parentUserId;

  Employee({
    required this.id,
    required this.firstName,
    this.middleName,
    required this.paternalSurname,
    required this.maternalSurname,
    required this.phone,
    required this.userId,
    required this.userEmail,
    required this.userRole,
    required this.salary,
    required this.createdAt,
    required this.roleId,
    this.parentUserId,
  });

  /// Nombre completo
  String get fullName {
    final full =
        '$firstName ${middleName ?? ''} $paternalSurname $maternalSurname';
    return full.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Nombre corto
  String get shortName {
    return '$firstName $paternalSurname $maternalSurname'.trim();
  }

  /// Estado del empleado
  EmployeeStatus get status {
    return EmployeeStatus.active;
  }

  /// Última actividad
  DateTime get lastActive => createdAt;

  /// Avatar generado automáticamente
  String get avatarUrl {
    return 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(fullName)}&background=4CAF50&color=fff';
  }

  /// Departamento derivado del rol
  String get department {
    switch (roleId) {
      case 1:
        return 'Administración';
      case 2:
        return 'Ventas';
      case 3:
        return 'Supervisión';
      case 4:
        return 'Gerencia';
      default:
        return 'General';
    }
  }

  /// Fecha de ingreso
  DateTime get joinDate => createdAt;

  factory Employee.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data;

    if (json.containsKey('data') && json['data'] != null) {
      data = json['data'] as Map<String, dynamic>;
    } else {
      data = json;
    }

    return Employee(
      id: data['id'] ?? 0,
      firstName: data['firstName'] ?? '',
      middleName: data['middleName'],
      paternalSurname: data['paternalSurname'] ?? '',
      maternalSurname: data['maternalSurname'] ?? '',
      phone: data['phone'] ?? '',
      userId: data['userId'] ?? 0,
      userEmail: data['userEmail'] ?? '',
      userRole: data['userRole']?.toString() ?? '',
      salary: (data['salary'] ?? 0).toDouble(),
      createdAt: DateTime.tryParse(
        data['createdAt']?.toString() ?? '',
      ) ??
          DateTime.now(),
      roleId: data['roleId'] ?? 0,
      parentUserId: data['parentUserId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'middleName': middleName,
      'paternalSurname': paternalSurname,
      'maternalSurname': maternalSurname,
      'phone': phone,
      'userId': userId,
      'userEmail': userEmail,
      'userRole': userRole,
      'salary': salary,
      'createdAt': createdAt.toIso8601String(),
      'roleId': roleId,
      'parentUserId': parentUserId,
    };
  }
}

// DTO para crear/actualizar empleados
class CreateEmployeeRequest {
  final String firstName;
  final String? middleName;
  final String paternalSurname;
  final String maternalSurname;
  final String phone;
  final String email;
  final String password;
  final int roleId;
  final double salary;
  final int? parentUserId;

  const CreateEmployeeRequest({
    required this.firstName,
    this.middleName,
    required this.paternalSurname,
    required this.maternalSurname,
    required this.phone,
    required this.email,
    required this.password,
    required this.roleId,
    required this.salary,
    this.parentUserId,
  });

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'middleName': middleName,
    'paternalSurname': paternalSurname,
    'maternalSurname': maternalSurname,
    'phone': phone,
    'email': email,
    'password': password,
    'roleId': roleId,
    'salary': salary,
    'parentUserId': parentUserId,
  };
}

// DTO para actualizar empleado
class UpdateEmployeeRequest {
  final String firstName;
  final String? middleName;
  final String paternalSurname;
  final String maternalSurname;
  final String phone;
  final double salary;
  final int? parentUserId;

  UpdateEmployeeRequest({
    required this.firstName,
    this.middleName,
    required this.paternalSurname,
    required this.maternalSurname,
    required this.phone,
    required this.salary,
    this.parentUserId,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'paternalSurname': paternalSurname,
      'maternalSurname': maternalSurname,
      'phone': phone,
      'salary': salary,
      'parentUserId': parentUserId,
    };
  }
}