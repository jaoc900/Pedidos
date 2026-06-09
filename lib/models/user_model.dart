// models/user_model.dart
class UserModel {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String fullName;
  final String? phone;
  final String? address;
  final String? profilePictureUrl;
  final String role;
  final String? lastSession;
  final String? createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    this.phone,
    this.address,
    this.profilePictureUrl,
    required this.role,
    this.lastSession,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print('Creando UserModel desde JSON: $json');

    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      fullName: json['fullName'] ?? '',
      phone: json['phone'],
      address: json['address'],
      profilePictureUrl: json['profilePictureUrl'],
      role: json['role']?.toString() ?? '0',
      lastSession: json['lastSession'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'profilePictureUrl': profilePictureUrl,
      'role': role,
      'lastSession': lastSession,
      'createdAt': createdAt,
    };
  }
}