// login_response.dart

class LoginResponse {
  final bool success;
  final UserData data;

  LoginResponse({
    required this.success,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      data: UserData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.toJson(),
    };
  }
}

class UserData {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final int role;
  final String token;
  final String refreshToken;
  final DateTime expiresAt;

  UserData({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.token,
    required this.refreshToken,
    required this.expiresAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      role: json['role'] ?? 0,
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      expiresAt: DateTime.parse(json['expiresAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'token': token,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  // Método útil para obtener el nombre completo
  String get fullName => '$firstName $lastName';

  // Método para verificar si el token ha expirado
  bool get isTokenExpired => DateTime.now().isAfter(expiresAt);

  // Método para saber si es administrador (role = 4)
  bool get isAdmin => role == 4;

  // Método para saber si es usuario normal
  bool get isNormalUser => role == 1;
}