import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/digital_id.dart';

final vaultProvider = StateNotifierProvider<VaultNotifier, List<DigitalID>>((ref) {
  return VaultNotifier();
});

class VaultNotifier extends StateNotifier<List<DigitalID>> {
  VaultNotifier() : super([
    DigitalID(
      fullName: 'Abebe Bikila',
      fin: '1234 5678 9012',
      dob: '12 OCT 1990',
      gender: 'MALE',
      issueDate: '01 JAN 2024',
      expiryDate: '01 JAN 2034',
      photo: '',
    ),
  ]);

  void addId(DigitalID id) {
    state = [...state, id];
  }

  void removeId(String fin) {
    state = state.where((id) => id.fin != fin).toList();
  }
}
