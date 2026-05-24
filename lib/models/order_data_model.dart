import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrderItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  final String imageUrl;

  OrderItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}

class OrderData {
  final String id;
  final String date;
  final String address;
  final double amount;
  final String status;
  final Color statusColor;
  final Color statusBgColor;
  final FaIconData statusIcon;
  final String client;
  final int items;
  final List<OrderItem> orderItems;
  final String? notes;
  final String? deliveryMethod;
  final DateTime? deliveryDate;

  OrderData({
    required this.id,
    required this.date,
    required this.address,
    required this.amount,
    required this.status,
    required this.statusColor,
    required this.statusBgColor,
    required this.statusIcon,
    required this.client,
    required this.items,
    this.orderItems = const [],
    this.notes,
    this.deliveryMethod,
    this.deliveryDate,
  });

  // Método de fábrica para crear desde diferentes fuentes
  factory OrderData.fromSimple({
    required String id,
    required String date,
    required double amount,
    required String status,
    required Color statusColor,
    required Color statusBgColor,
    String client = '',
    int items = 0,
  }) {
    return OrderData(
      id: id,
      date: date,
      address: '',
      amount: amount,
      status: status,
      statusColor: statusColor,
      statusBgColor: statusBgColor,
      statusIcon: _getStatusIcon(status),
      client: client,
      items: items,
    );
  }

  factory OrderData.fromDetailed({
    required String id,
    required String address,
    required String status,
    required double amount,
    required Color statusColor,
    required FaIconData statusIcon,
    required String client,
    required int items,
    List<OrderItem> orderItems = const [],
    String? notes,
    String? deliveryMethod,
    DateTime? deliveryDate,
  }) {
    return OrderData(
      id: id,
      date: '',
      address: address,
      amount: amount,
      status: status,
      statusColor: statusColor,
      statusBgColor: statusColor.withValues(alpha: 0.2),
      statusIcon: statusIcon,
      client: client,
      items: items,
      orderItems: orderItems,
      notes: notes,
      deliveryMethod: deliveryMethod,
      deliveryDate: deliveryDate,
    );
  }

  // Constructor para órdenes completas con items
  factory OrderData.withItems({
    required String id,
    required String date,
    required String address,
    required double amount,
    required String status,
    required Color statusColor,
    required Color statusBgColor,
    required String client,
    required List<OrderItem> orderItems,
    String? notes,
    String? deliveryMethod,
    DateTime? deliveryDate,
  }) {
    final totalItems = orderItems.fold(0, (sum, item) => sum + item.quantity);
    return OrderData(
      id: id,
      date: date,
      address: address,
      amount: amount,
      status: status,
      statusColor: statusColor,
      statusBgColor: statusBgColor,
      statusIcon: _getStatusIcon(status),
      client: client,
      items: totalItems,
      orderItems: orderItems,
      notes: notes,
      deliveryMethod: deliveryMethod,
      deliveryDate: deliveryDate,
    );
  }

  static FaIconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completado':
      case 'pagada':
        return FontAwesomeIcons.circleCheck;
      case 'entregada':
        return FontAwesomeIcons.circleCheck;
      case 'en camino':
      case 'en ruta':
        return FontAwesomeIcons.truck;
      case 'pendiente':
        return FontAwesomeIcons.clock;
      default:
        return FontAwesomeIcons.box;
    }
  }

  // Método para calcular el subtotal de los items
  double get subtotal => orderItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  // Método para obtener el total de items (incluyendo cantidades)
  int get totalItems => orderItems.fold(0, (sum, item) => sum + item.quantity);

  // Método para obtener la cantidad de productos únicos
  int get uniqueItems => orderItems.length;

  // Método para verificar si la orden tiene items
  bool get hasItems => orderItems.isNotEmpty;

  // Método para obtener el formato de fecha
  String get formattedDate {
    if (date.isNotEmpty) return date;
    if (deliveryDate != null) {
      return '${deliveryDate!.day}/${deliveryDate!.month}/${deliveryDate!.year}';
    }
    return '';
  }

  // Método para actualizar la cantidad de un item
  OrderData updateItemQuantity(String itemId, int newQuantity) {
    final updatedItems = orderItems.map((item) {
      if (item.id == itemId) {
        return OrderItem(
          id: item.id,
          name: item.name,
          price: item.price,
          quantity: newQuantity,
          imageUrl: item.imageUrl,
        );
      }
      return item;
    }).toList();

    return OrderData(
      id: id,
      date: date,
      address: address,
      amount: amount,
      status: status,
      statusColor: statusColor,
      statusBgColor: statusBgColor,
      statusIcon: statusIcon,
      client: client,
      items: updatedItems.fold(0, (sum, i) => sum + i.quantity),
      orderItems: updatedItems,
      notes: notes,
      deliveryMethod: deliveryMethod,
      deliveryDate: deliveryDate,
    );
  }

  // Método para agregar un item a la orden
  OrderData addItem(OrderItem newItem) {
    final existingIndex = orderItems.indexWhere((item) => item.id == newItem.id);
    List<OrderItem> updatedItems;

    if (existingIndex != -1) {
      updatedItems = orderItems.map((item) {
        if (item.id == newItem.id) {
          return OrderItem(
            id: item.id,
            name: item.name,
            price: item.price,
            quantity: item.quantity + newItem.quantity,
            imageUrl: item.imageUrl,
          );
        }
        return item;
      }).toList();
    } else {
      updatedItems = [...orderItems, newItem];
    }

    return OrderData(
      id: id,
      date: date,
      address: address,
      amount: amount,
      status: status,
      statusColor: statusColor,
      statusBgColor: statusBgColor,
      statusIcon: statusIcon,
      client: client,
      items: updatedItems.fold(0, (sum, i) => sum + i.quantity),
      orderItems: updatedItems,
      notes: notes,
      deliveryMethod: deliveryMethod,
      deliveryDate: deliveryDate,
    );
  }

  // Método para eliminar un item de la orden
  OrderData removeItem(String itemId) {
    final updatedItems = orderItems.where((item) => item.id != itemId).toList();

    return OrderData(
      id: id,
      date: date,
      address: address,
      amount: amount,
      status: status,
      statusColor: statusColor,
      statusBgColor: statusBgColor,
      statusIcon: statusIcon,
      client: client,
      items: updatedItems.fold(0, (sum, i) => sum + i.quantity),
      orderItems: updatedItems,
      notes: notes,
      deliveryMethod: deliveryMethod,
      deliveryDate: deliveryDate,
    );
  }
}