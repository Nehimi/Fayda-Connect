
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../providers/user_provider.dart';
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
    final user = ref.read(userProvider);
    _nameController = TextEditingController(text: user.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.transparent,
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
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: const Icon(LucideIcons.user, color: AppColors.primary, size: 50),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.camera, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
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
            // Phone is usually not editable easily, but let's just show it as disabled
             GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextFormField(
                initialValue: '+251 911 234 567',
                readOnly: true,
                style: const TextStyle(color: AppColors.textDim, fontSize: 16),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(LucideIcons.phone, color: AppColors.textDim),
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: AppColors.textDim),
                ),
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  ref.read(userProvider.notifier).updateName(_nameController.text);
                  CustomSnackBar.show(context, message: 'Profile updated successfully!');
                  Navigator.pop(context);
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
