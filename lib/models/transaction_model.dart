import 'package:flutter/material.dart';

class TransactionData {
  final String name;
  final String time;
  final double amount;
  final String status;
  final Color statusColor;
  final bool isCompleted;

  TransactionData({
    required this.name,
    required this.time,
    required this.amount,
    required this.status,
    required this.statusColor,
    required this.isCompleted,
  });
}