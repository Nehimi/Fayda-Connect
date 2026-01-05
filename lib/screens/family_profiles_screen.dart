import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../providers/family_provider.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';
import '../models/family_member.dart';
import '../widgets/custom_snackbar.dart';

class FamilyProfilesScreen extends ConsumerWidget {
  const FamilyProfilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final family = ref.watch(familyProvider);
    final lang = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text(L10n.get(lang, 'family_profiles')),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L10n.get(lang, 'family_profiles'),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textMain, letterSpacing: -1),
            ),
            const SizedBox(height: 8),
            Text(
              L10n.get(lang, 'family_desc'),
              style: const TextStyle(color: AppColors.textDim, fontSize: 16),
            ),
            const SizedBox(height: 32),
            ...family.map((member) => _buildMemberCard(context, ref, member, lang)),
            const SizedBox(height: 16),
            _buildAddButton(context, lang),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCard(BuildContext context, WidgetRef ref, FamilyMember member, AppLanguage lang) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.user, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Text(
                    '${member.relationship} • ${member.fin}',
                    style: const TextStyle(color: AppColors.textDim, fontSize: 13),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(LucideIcons.trash2, color: Colors.redAccent, size: 20),
              onPressed: () {
                ref.read(familyProvider.notifier).removeMember(member.id);
                CustomSnackBar.show(context, message: 'Member removed');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, AppLanguage lang) {
    return InkWell(
      onTap: () => _showAddMemberDialog(context),
      borderRadius: BorderRadius.circular(20),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.plus, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(
              L10n.get(lang, 'add_member'),
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    // Simple mock dialog for adding
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Add Family Member', style: TextStyle(color: AppColors.textMain)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: const TextStyle(color: AppColors.textDim),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.glassBorder)),
              ),
              style: const TextStyle(color: AppColors.textMain),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Fayda FIN',
                labelStyle: const TextStyle(color: AppColors.textDim),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.glassBorder)),
              ),
              style: const TextStyle(color: AppColors.textMain),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          Consumer(builder: (context, ref, child) {
            return TextButton(
              onPressed: () {
                // Mock add
                ref.read(familyProvider.notifier).addMember(FamilyMember(
                  id: DateTime.now().toString(),
                  name: 'New Member',
                  relationship: 'Family',
                  fin: 'FIN-XXXX-XXXX',
                ));
                Navigator.pop(context);
                CustomSnackBar.show(context, message: 'Added successfully');
              },
              child: const Text('Add'),
            );
          }),
        ],
      ),
    );
  }
}
