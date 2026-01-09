import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/colors.dart';
import '../widgets/glass_card.dart';
import '../screens/home_screen.dart';
import '../screens/premium_screen.dart';
import '../screens/bank_list_screen.dart';
import '../screens/order_history_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/help_support_screen.dart';
import '../providers/language_provider.dart';
import '../theme/l10n.dart';
import '../screens/academy_screen.dart';
import '../screens/bank_comparison_screen.dart';
import '../screens/scanner_screen.dart';
import '../widgets/custom_snackbar.dart';
import '../services/auth_service.dart';
import '../screens/profile_edit_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/emergency_screen.dart';
import '../providers/user_provider.dart';
import '../screens/news_list_screen.dart';
import '../utils/responsive.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateProvider);
    final user = userAsync.value;
    final appUser = ref.watch(userProvider);
    final displayName = user?.displayName ?? appUser.name;
    final isPremium = appUser.isPremium;
    final r = context.responsive;
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
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileEditScreen()));
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(24, r.getSpacing(64), 24, r.getSpacing(32)),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: AppColors.meshGradient,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: r.getSpacing(64),
                            height: r.getSpacing(64),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 4),
                            ),
                            child: Icon(LucideIcons.user, color: AppColors.primary, size: r.getIconSize(32)),
                          ),
                          SizedBox(height: r.getSpacing(16)),
                          Text(
                            displayName,
                            style: TextStyle(color: Colors.white, fontSize: r.getFontSize(22), fontWeight: FontWeight.w900, letterSpacing: -0.5),
                          ),
                          Row(
                            children: [
                               Text(
                                isPremium ? 'Verified Professional' : 'Standard Status',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: r.getFontSize(13), fontWeight: FontWeight.w600),
                              ),
                              if (isPremium) ...[
                                SizedBox(width: r.getSpacing(8)),
                                Icon(LucideIcons.crown, color: Colors.amber, size: r.getIconSize(16)),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: r.getSpacing(16)),
                  _DrawerItem(context, ref, LucideIcons.home, L10n.get(ref.watch(languageProvider), 'home'), route: 'home'),
                   _DrawerItem(context, ref, LucideIcons.alertCircle, 'Emergency ID', route: 'emergency', color: Colors.redAccent),
                   _DrawerItem(context, ref, LucideIcons.shieldCheck, L10n.get(ref.watch(languageProvider), 'pro'), route: 'pro', color: Colors.amber),
                   _DrawerItem(context, ref, LucideIcons.scan, L10n.get(ref.watch(languageProvider), 'scan_id'), route: 'scanner'),
                   _DrawerItem(context, ref, LucideIcons.graduationCap, L10n.get(ref.watch(languageProvider), 'academy'), route: 'academy'),
                   _DrawerItem(context, ref, LucideIcons.megaphone, L10n.get(ref.watch(languageProvider), 'news_feed'), route: 'news'),
                   _DrawerItem(context, ref, LucideIcons.trendingUp, L10n.get(ref.watch(languageProvider), 'comparison'), route: 'comparison'),
                   _DrawerItem(context, ref, LucideIcons.history, L10n.get(ref.watch(languageProvider), 'order_history'), route: 'history'),
                   const Divider(color: AppColors.glassBorder, height: 40, indent: 24, endIndent: 24),
                   _DrawerItem(context, ref, LucideIcons.settings, L10n.get(ref.watch(languageProvider), 'settings'), route: 'settings'),
                  _DrawerItem(context, ref, LucideIcons.helpCircle, L10n.get(ref.watch(languageProvider), 'help'), route: 'help'),
                  SizedBox(height: r.getSpacing(16)),
                ],
              ),
            ),
             _DrawerItem(context, ref, LucideIcons.logOut, L10n.get(ref.watch(languageProvider), 'sign_out'), color: Colors.redAccent, route: 'logout'),
             SizedBox(height: r.getSpacing(32)),
           ],
        ),
      ),
    );
  }

  Widget _DrawerItem(BuildContext context, WidgetRef ref, IconData icon, String label, {required String route, Color? color}) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    // Check if it's the home screen or the current active route
    bool isActive = (route == 'home' && (currentRoute == '/' || currentRoute == null)) || (currentRoute == route);

    final r = context.responsive;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.getSpacing(14), vertical: r.getSpacing(4)),
      child: ListTile(
        onTap: () {
          Navigator.pop(context); // Close drawer
          
          if (route == 'home') {
             // Home is our root via AuthGate, just go back to first route
             Navigator.popUntil(context, (route) => route.isFirst);
          } else if (route == 'pro') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PremiumScreen(), settings: const RouteSettings(name: 'pro')));
          } else if (route == 'emergency') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const EmergencyScreen(), settings: const RouteSettings(name: 'emergency')));
          } else if (route == 'history') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderHistoryScreen(), settings: const RouteSettings(name: 'history')));
          } else if (route == 'settings') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen(), settings: const RouteSettings(name: 'settings')));
          } else if (route == 'help') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportScreen(), settings: const RouteSettings(name: 'help')));
          } else if (route == 'scanner') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ScannerScreen(), settings: const RouteSettings(name: 'scanner')));
          } else if (route == 'academy') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AcademyScreen(), settings: const RouteSettings(name: 'academy')));
          } else if (route == 'comparison') {
             Navigator.push(context, MaterialPageRoute(builder: (context) => const BankComparisonScreen(), settings: const RouteSettings(name: 'comparison')));
          } else if (route == 'news') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const NewsListScreen(), settings: const RouteSettings(name: 'news')));
          } else if (route == 'logout') {
             CustomSnackBar.show(context, message: 'Logging out...');
             // AuthGate will handle the UI switch automatically
             Navigator.popUntil(context, (route) => route.isFirst);
             ref.read(authServiceProvider).signOut();
          }
        },
        leading: Icon(icon, color: color ?? (isActive ? AppColors.primary : AppColors.textDim), size: r.getIconSize(22)),
        title: Text(
          label,
          style: TextStyle(
            color: color ?? (isActive ? AppColors.textMain : AppColors.textDim),
            fontWeight: isActive ? FontWeight.w900 : FontWeight.w600,
            fontSize: r.getFontSize(15),
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tileColor: isActive ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
      ),
    );
  }
}

