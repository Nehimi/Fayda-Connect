import 'package:flutter/material.dart';

class ServiceCategory {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  ServiceCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
