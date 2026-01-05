
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  UserNotifier() : super(AppUser(name: 'Abenezer Kebede', isPremium: false));

  void setPremium(bool value) {
    state = state.copyWith(isPremium: value);
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, AppUser>((ref) {
  return UserNotifier();
});
