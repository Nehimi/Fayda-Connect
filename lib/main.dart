import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'debug/translation_upload_screen.dart';
import 'theme/app_theme.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'providers/auth_ui_provider.dart';
import 'screens/auth/otp_verification_screen.dart';
import 'utils/database_seeder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
    
    // Pass all uncaught errors from the framework to Crashlytics.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics.
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    await NotificationService.initialize();
    
    // Seed the database with initial services data
    await DatabaseSeeder.seedServices();
  } catch (e) {
    debugPrint("Firebase not configured yet: $e");
  }

  runApp(
    const ProviderScope(
      child: FaydaConnectApp(),
    ),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class FaydaConnectApp extends StatelessWidget {
  const FaydaConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fayda Connect',
      navigatorKey: navigatorKey, // Use global key for stable navigation
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const AuthGate(),
      routes: {
        '/debug/upload': (context) => const TranslationUploadScreen(),
      },
    );
  }
}


class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final showLogin = ref.watch(showLoginProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          // Check if email is verified
          if (user.emailVerified) {
            return const HomeScreen();
          } else {
            // Show verification screen as a gateway
            return OtpVerificationScreen(
              phoneNumber: user.email ?? 'Email',
              verificationId: 'EMAIL_LINK_FLOW',
              isSignUp: false, // Firestore profile is already created
            );
          }
        }
        if (showLogin) {
          return const LoginScreen();
        }
        return const OnboardingScreen();
      },
      loading: () => const Scaffold(
        body: Center(child: Text('Loading...')),
      ),
      error: (e, _) => const OnboardingScreen(),
    );
  }
}
