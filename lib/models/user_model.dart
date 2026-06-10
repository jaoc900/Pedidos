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
  final String? profilePictureBase64;
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
    this.profilePictureBase64,
    required this.role,
    this.lastSession,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print('Creando UserModel desde JSON: $json');

    // Extraer los datos de la sección 'data' si existe
    Map<String, dynamic> userData;
    if (json.containsKey('data') && json['data'] != null) {
      userData = json['data'] as Map<String, dynamic>; // ✅ Corregido: dynamic con minúscula
      print('Usando datos de la sección data: $userData');
    } else {
      userData = json;
      print('Usando JSON directamente: $userData');
    }

    // Limpiar base64 si existe (remover el prefijo "data:image/jpeg;base64,")
    String? cleanBase64;
    if (userData['profilePictureBase64'] != null) {
      String base64String = userData['profilePictureBase64'].toString();
      // Si el string contiene el prefijo data:image, lo removemos
      if (base64String.contains(',')) {
        cleanBase64 = base64String.substring(base64String.indexOf(',') + 1);
        print('Base64 limpiado, primeros 50 chars: ${cleanBase64.substring(0, cleanBase64.length > 50 ? 50 : cleanBase64.length)}...');
      } else {
        cleanBase64 = base64String;
      }
    }

    return UserModel(
      id: userData['id'] ?? 0,
      email: userData['email'] ?? '',
      firstName: userData['firstName'] ?? '',
      lastName: userData['lastName'] ?? '',
      fullName: userData['fullName'] ?? '',
      phone: userData['phone'],
      address: userData['address'],
      profilePictureUrl: userData['profilePictureUrl'],
      profilePictureBase64: cleanBase64, // Usar la versión limpia
      role: userData['role']?.toString() ?? '0',
      lastSession: userData['lastSession'],
      createdAt: userData['createdAt'],
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
      'profilePictureBase64': profilePictureBase64,
      'role': role,
      'lastSession': lastSession,
      'createdAt': createdAt,
    };
  }
}