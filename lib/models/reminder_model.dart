import 'package:flutter/material.dart';

class Reminder {
  final String id;
  final String title;
  final String description;
  final DateTime expiryDate;
  final IconData icon;
  final Color color;

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.expiryDate,
    required this.icon,
    required this.color,
  });
}
