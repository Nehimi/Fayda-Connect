import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/family_member.dart';

final familyProvider = StateNotifierProvider<FamilyNotifier, List<FamilyMember>>((ref) {
  return FamilyNotifier();
});

class FamilyNotifier extends StateNotifier<List<FamilyMember>> {
  FamilyNotifier() : super([
    FamilyMember(
      id: '1',
      name: 'Marta Abebe',
      relationship: 'Spouse',
      fin: 'FIN-5566-7788',
    ),
    FamilyMember(
      id: '2',
      name: 'Dawit Abebe',
      relationship: 'Son',
      fin: 'FIN-9900-1122',
    ),
  ]);

  void addMember(FamilyMember member) {
    state = [...state, member];
  }

  void removeMember(String id) {
    state = state.where((m) => m.id != id).toList();
  }
}
