import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final Ref ref;
  UserNotifier(this.ref) : super(AppUser(name: 'Official Member', isPremium: false)) {
    _init();
    _listenToAuth();
  }

  void _init() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        state = state.copyWith(name: user.displayName);
      }
      _listenToDatabase(user.uid);
    }
  }

  void _listenToAuth() {
    ref.listen(authStateProvider, (previous, next) {
      final user = next.value;
      if (user != null) {
        if (user.displayName != null && user.displayName!.isNotEmpty) {
          state = state.copyWith(name: user.displayName);
        }
        _listenToDatabase(user.uid);
      }
    });
  }

  void _listenToDatabase(String uid) {
    FirebaseDatabase.instance.ref('users/$uid').onValue.listen((event) {
      if (event.snapshot.value == null) return;
      final data = event.snapshot.value as Map?;
      if (data != null) {
        state = state.copyWith(
          name: data['name'] ?? state.name,
          isPremium: data['isPremium'] ?? false,
        );
      }
    });
  }

  void setPremium(bool value) {
    state = state.copyWith(isPremium: value);
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, AppUser>((ref) {
  return UserNotifier(ref);
});
