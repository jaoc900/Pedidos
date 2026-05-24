import 'package:pedidos/enums/delivery_status_enum.dart';

class Delivery {
  final String id;
  final String orderId;
  final String client;
  final String address;
  DeliveryStatus status;
  final DateTime estimatedTime;
  final double amount;
  final int items;
  final String contactPhone;
  final String notes;
  final double lat;
  final double lng;
  DateTime? deliveredAt;

  Delivery({
    required this.id,
    required this.orderId,
    required this.client,
    required this.address,
    required this.status,
    required this.estimatedTime,
    required this.amount,
    required this.items,
    required this.contactPhone,
    required this.notes,
    required this.lat,
    required this.lng,
    this.deliveredAt,
  });
}