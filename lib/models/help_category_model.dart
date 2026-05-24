import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:pedidos/models/help_article_model.dart';

class HelpCategory {
  final String title;
  final FaIconData icon;
  final Color color;
  final List<HelpArticle> articles;

  HelpCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.articles,
  });
}