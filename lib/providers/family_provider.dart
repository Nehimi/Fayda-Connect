import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/family_member.dart';
import '../services/sync_service.dart';
import '../services/auth_service.dart';

final familyProvider = StreamProvider<List<FamilyMember>>((ref) {
  final user = ref.watch(authStateProvider).asData?.value;
  if (user == null) {
     return Stream.value([]);
  }
  return ref.watch(syncServiceProvider).watchFamily(user.uid);
});
