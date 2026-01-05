import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/reminder_model.dart';

final remindersProvider = StateProvider<List<Reminder>>((ref) {
  return [
    Reminder(
      id: 'rem_1',
      title: 'Passport Renewal',
      description: 'Your passport expires in 85 days. Renew now to avoid travel delays.',
      expiryDate: DateTime.now().add(const Duration(days: 85)),
      icon: LucideIcons.contact,
      color: const Color(0xFF10B981),
    ),
    Reminder(
      id: 'rem_2',
      title: 'Business License',
      description: 'Trade license renewal due soon. Last date for early bird discount is 12 March.',
      expiryDate: DateTime.now().add(const Duration(days: 92)),
      icon: LucideIcons.briefcase,
      color: const Color(0xFFF59E0B),
    ),
  ];
});
