import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../providers/language_provider.dart';
import '../providers/reminder_provider.dart';
import '../theme/l10n.dart';
import '../widgets/custom_snackbar.dart';

class RemindersListScreen extends ConsumerWidget {
  const RemindersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final reminders = ref.watch(remindersProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text(L10n.get(lang, 'alerts')),
        backgroundColor: Colors.transparent,
      ),
      body: reminders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.bellRing, size: 64, color: AppColors.textDim.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text(
                    lang == AppLanguage.english ? 'No new updates' : 'ምንም አዲስ ማስታወቂያ የለም',
                    style: const TextStyle(color: AppColors.textDim),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                return Dismissible(
                  key: Key(reminder.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(LucideIcons.trash2, color: Colors.redAccent),
                  ),
                  onDismissed: (direction) {
                    final currentReminders = ref.read(remindersProvider);
                    ref.read(remindersProvider.notifier).state = currentReminders.where((r) => r.id != reminder.id).toList();
                    CustomSnackBar.show(context, message: lang == AppLanguage.english ? 'Reminder removed' : 'ማሳሰቢያው ተወግዷል');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GlassCard(
                      padding: const EdgeInsets.all(20),
                      gradientColors: [
                        reminder.color.withValues(alpha: 0.1),
                        reminder.color.withValues(alpha: 0.05),
                      ],
                      borderColor: reminder.color.withValues(alpha: 0.3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: reminder.color.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(reminder.icon, color: reminder.color, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  L10n.getLocalized(lang, reminder.title),
                                  style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.w900, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  L10n.getLocalized(lang, reminder.description),
                                  style: TextStyle(color: AppColors.textMain.withValues(alpha: 0.7), fontSize: 13, height: 1.5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
