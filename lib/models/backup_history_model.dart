import 'package:pedidos/enums/backup_status_enum.dart';

class BackupHistory {
  final String id;
  final DateTime date;
  final String size;
  final String type;
  final BackupStatus status;

  BackupHistory({
    required this.id,
    required this.date,
    required this.size,
    required this.type,
    required this.status,
  });
}