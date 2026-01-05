
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../services/auth_service.dart';
import '../widgets/custom_snackbar.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authServiceProvider).currentUser;
    _nameController = TextEditingController(text: user?.displayName ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(authStateProvider);
    final user = userAsync.value;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text('Profile Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 4),
                    ),
                    child: const Icon(LucideIcons.user, color: AppColors.primary, size: 50),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user?.email ?? 'No Email',
              style: const TextStyle(color: AppColors.textDim, fontSize: 14),
            ),
            const SizedBox(height: 32),
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextFormField(
                controller: _nameController,
                style: const TextStyle(color: AppColors.textMain, fontSize: 16),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(LucideIcons.user, color: AppColors.textDim),
                  labelText: 'Full Name',
                  labelStyle: TextStyle(color: AppColors.textDim),
                ),
              ),
            ),
            const SizedBox(height: 16),
             GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextFormField(
                initialValue: user?.email ?? '',
                readOnly: true,
                style: const TextStyle(color: AppColors.textDim, fontSize: 16),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(LucideIcons.mail, color: AppColors.textDim),
                  labelText: 'Email Address',
                  labelStyle: TextStyle(color: AppColors.textDim),
                ),
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isNotEmpty) {
                  try {
                    await ref.read(authServiceProvider).updateDisplayName(_nameController.text);
                    if (mounted) {
                      CustomSnackBar.show(context, message: 'Profile updated successfully!');
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    if (mounted) {
                      CustomSnackBar.show(context, message: 'Update failed: $e', isError: true);
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
