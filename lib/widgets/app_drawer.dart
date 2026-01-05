import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../screens/home_screen.dart';
import '../screens/premium_screen.dart';
import '../screens/bank_list_screen.dart';
import '../screens/vault_screen.dart';
import '../screens/order_history_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/help_support_screen.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: GlassCard(
        borderRadius: 0,
        padding: EdgeInsets.zero,
        gradientColors: [
          AppColors.scaffold,
          AppColors.scaffold.withValues(alpha: 0.95),
        ],
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(24, 80, 24, 40),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppColors.meshGradient,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 4),
                    ),
                    child: const Icon(LucideIcons.user, color: AppColors.primary, size: 32),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Abenezer Kebede',
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                  ),
                  Text(
                    L10n.get(ref.watch(languageProvider), 'premium'),
                    style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _DrawerItem(context, ref, LucideIcons.home, L10n.get(ref.watch(languageProvider), 'home'), route: 'home'),
            _DrawerItem(context, ref, LucideIcons.wallet, L10n.get(ref.watch(languageProvider), 'vault'), route: 'vault'),
            _DrawerItem(context, ref, LucideIcons.history, L10n.get(ref.watch(languageProvider), 'history'), route: 'history'),
            _DrawerItem(context, ref, LucideIcons.crown, L10n.get(ref.watch(languageProvider), 'pro'), color: AppColors.accent, route: 'pro'),
            const Divider(color: AppColors.glassBorder, height: 40, indent: 24, endIndent: 24),
            _DrawerItem(context, ref, LucideIcons.settings, L10n.get(ref.watch(languageProvider), 'settings'), route: 'settings'),
            _DrawerItem(context, ref, LucideIcons.helpCircle, L10n.get(ref.watch(languageProvider), 'help'), route: 'help'),
            const Spacer(),
            _DrawerItem(context, ref, LucideIcons.logOut, L10n.get(ref.watch(languageProvider), 'sign_out'), color: Colors.redAccent, route: 'logout'),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _DrawerItem(BuildContext context, WidgetRef ref, IconData icon, String label, {required String route, Color? color}) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    // Check if it's the home screen or the current active route
    bool isActive = (route == 'home' && (currentRoute == '/' || currentRoute == null)) || (currentRoute == route);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: () {
          Navigator.pop(context); // Close drawer
          
          if (route == 'home') {
             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen(), settings: const RouteSettings(name: 'home')), (route) => false);
          } else if (route == 'pro') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PremiumScreen(), settings: const RouteSettings(name: 'pro')));
          } else if (route == 'vault') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const VaultScreen(), settings: const RouteSettings(name: 'vault')));
          } else if (route == 'history') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderHistoryScreen(), settings: const RouteSettings(name: 'history')));
          } else if (route == 'settings') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen(), settings: const RouteSettings(name: 'settings')));
          } else if (route == 'help') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportScreen(), settings: const RouteSettings(name: 'help')));
          } else if (route == 'logout') {
             ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(
                 content: Text('Logging out...'),
                 behavior: SnackBarBehavior.floating,
                 backgroundColor: AppColors.primary,
               )
             );
          }
        },
        leading: Icon(icon, color: color ?? (isActive ? AppColors.primary : AppColors.textDim), size: 22),
        title: Text(
          label,
          style: TextStyle(
            color: color ?? (isActive ? AppColors.textMain : AppColors.textDim),
            fontWeight: isActive ? FontWeight.w900 : FontWeight.w600,
            fontSize: 15,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tileColor: isActive ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
      ),
    );
  }
}
