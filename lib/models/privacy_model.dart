import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PrivacySection {
  final String number;
  final String title;
  final String content;
  final bool hasIcon;
  final FaIconData? icon;
  final bool isHighlighted;
  final bool hasContact;
  final String contactEmail;

  PrivacySection({
    required this.number,
    required this.title,
    required this.content,
    this.hasIcon = false,
    this.icon,
    this.isHighlighted = false,
    this.hasContact = false,
    this.contactEmail = '',
  });
}