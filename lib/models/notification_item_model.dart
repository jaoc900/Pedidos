import 'package:pedidos/enums/notification_type_enum.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final NotificationType type;
  bool isRead;
  final String imageUrl;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.isRead,
    required this.imageUrl,
  });
}