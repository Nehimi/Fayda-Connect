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
import '../services/auth_service.dart';
import '../services/sync_service.dart';

class FamilyProfilesScreen extends ConsumerWidget {
  const FamilyProfilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final familyAsync = ref.watch(familyProvider);
    final lang = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text(L10n.get(lang, 'family_profiles')),
        backgroundColor: Colors.transparent,
      ),
      body: familyAsync.when(
        data: (family) => SingleChildScrollView(
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
              if (family.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(LucideIcons.users, size: 64, color: AppColors.textDim.withValues(alpha: 0.2)),
                        const SizedBox(height: 16),
                        const Text(
                          "No family members linked yet.",
                          style: TextStyle(color: AppColors.textDim),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...family.map((member) => _buildMemberCard(context, ref, member, lang)),
              const SizedBox(height: 16),
              _buildAddButton(context, lang),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
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
              onPressed: () async {
                final user = ref.read(authServiceProvider).currentUser;
                if (user != null) {
                  await ref.read(syncServiceProvider).deleteFamilyMember(user.uid, member.id);
                  if (context.mounted) {
                    CustomSnackBar.show(context, message: 'Member removed');
                  }
                }
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
    final nameController = TextEditingController();
    final finController = TextEditingController();
    final relController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Add Family Member', style: TextStyle(color: AppColors.textMain)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: TextStyle(color: AppColors.textDim),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.glassBorder)),
                ),
                style: const TextStyle(color: AppColors.textMain),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: finController,
                decoration: const InputDecoration(
                  labelText: 'Fayda FIN',
                  labelStyle: TextStyle(color: AppColors.textDim),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.glassBorder)),
                ),
                style: const TextStyle(color: AppColors.textMain),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: relController,
                decoration: const InputDecoration(
                  labelText: 'Relationship (e.g. Spouse, Son)',
                  labelStyle: TextStyle(color: AppColors.textDim),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.glassBorder)),
                ),
                style: const TextStyle(color: AppColors.textMain),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          Consumer(builder: (context, ref, child) {
            return TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty && finController.text.isNotEmpty) {
                  final user = ref.read(authServiceProvider).currentUser;
                  if (user != null) {
                    final member = FamilyMember(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                      relationship: relController.text.isNotEmpty ? relController.text : 'Family',
                      fin: finController.text,
                    );
                    await ref.read(syncServiceProvider).syncFamilyMember(user.uid, member);
                    if (context.mounted) {
                      Navigator.pop(context);
                      CustomSnackBar.show(context, message: 'Added successfully');
                    }
                  }
                } else {
                  CustomSnackBar.show(context, message: 'Please fill name and FIN', isError: true);
                }
              },
              child: const Text('Add'),
            );
          }),
        ],
      ),
    );
  }
}
