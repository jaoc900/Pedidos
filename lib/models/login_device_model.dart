import 'package:pedidos/enums/device_type_enum.dart';

class LoginDevice {
  final String id;
  final String name;
  final String location;
  final DateTime lastActive;
  final bool isCurrent;
  final DeviceType deviceType;

  LoginDevice({
    required this.id,
    required this.name,
    required this.location,
    required this.lastActive,
    required this.isCurrent,
    required this.deviceType,
  });
}