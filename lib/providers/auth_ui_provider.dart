import 'package:flutter_riverpod/flutter_riverpod.dart';

// Global provider to switch between Onboarding and Login for guest users
final showLoginProvider = StateProvider<bool>((ref) => false);
