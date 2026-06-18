// lib/models/user_preferences_model.dart
class UserPreferencesModel {
  final int? id;
  final int? userId;
  final bool sendSms;
  final bool sendPush;

  UserPreferencesModel({
    this.id,
    this.userId,
    required this.sendSms,
    required this.sendPush,
  });

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return UserPreferencesModel(
      id: data['id'],
      userId: data['userId'],
      sendSms: data['sendSms'] ?? false,
      sendPush: data['sendPush'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'sendSms': sendSms,
      'sendPush': sendPush,
    };
  }

  // Copiar con cambios
  UserPreferencesModel copyWith({
    int? id,
    int? userId,
    bool? sendSms,
    bool? sendPush,
  }) {
    return UserPreferencesModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sendSms: sendSms ?? this.sendSms,
      sendPush: sendPush ?? this.sendPush,
    );
  }
}