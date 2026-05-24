import 'package:pedidos/enums/login_status_enum.dart';

class LoginHistory {
  final String id;
  final DateTime date;
  final String location;
  final String device;
  final String ip;
  final LoginStatus status;

  LoginHistory({
    required this.id,
    required this.date,
    required this.location,
    required this.device,
    required this.ip,
    required this.status,
  });
}