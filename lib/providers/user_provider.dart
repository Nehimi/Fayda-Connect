import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import '../services/auth_service.dart';

class AppUser {
  final String name;
  final bool isPremium;

  AppUser({required this.name, this.isPremium = false});

  AppUser copyWith({String? name, bool? isPremium}) {
    return AppUser(
      name: name ?? this.name,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}

class UserNotifier extends StateNotifier<AppUser> {
  UserNotifier(Ref ref) : super(AppUser(name: 'User', isPremium: false)) {
    // Listen to Auth Changes
    ref.listen(authStateProvider, (previous, next) {
      final authUser = next.value;
      if (authUser == null) {
        state = AppUser(name: 'Guest', isPremium: false);
      } else {
        // Sync with Realtime Database
        FirebaseDatabase.instance.ref('users/${authUser.uid}').onValue.listen((event) {
          final data = event.snapshot.value as Map?;
          if (data != null) {
            state = AppUser(
              name: data['name'] ?? authUser.displayName ?? 'User',
              isPremium: data['isPremium'] == true,
            );
          } else {
            // Initialize user in DB if not exists
            FirebaseDatabase.instance.ref('users/${authUser.uid}').set({
              'name': authUser.displayName ?? 'User',
              'isPremium': false,
            });
            state = AppUser(name: authUser.displayName ?? 'User', isPremium: false);
          }
        });
      }
    });

    // Handle initial state if already logged in
    final authUser = ref.read(authStateProvider).value;
    if (authUser != null) {
       _initSync(authUser);
    }
  }

  void _initSync(dynamic authUser) {
    FirebaseDatabase.instance.ref('users/${authUser.uid}').onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        state = AppUser(
          name: data['name'] ?? authUser.displayName ?? 'User',
          isPremium: data['isPremium'] == true,
        );
      }
    });
  }

  void setPremium(bool value) {
    state = state.copyWith(isPremium: value);
    // Note: In a real app, we update the DB here if the user pays.
    // But here, the Admin Bot does it.
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, AppUser>((ref) {
  return UserNotifier(ref);
});
