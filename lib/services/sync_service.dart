import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/family_member.dart';

final syncServiceProvider = Provider((ref) => SyncService());

class SyncService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create/Update basic user profile
  Future<void> createUserProfile(String userId, String name, String phone) async {
    await _db.collection('users').doc(userId).set({
      'name': name,
      'phone': phone,
      'createdAt': FieldValue.serverTimestamp(),
      'isPremium': false,
    }, SetOptions(merge: true));
  }

  // Fetch user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    return doc.exists ? doc.data() : null;
  }

  // Sync family profile to cloud
  Future<void> syncFamilyMember(String userId, FamilyMember member) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('family')
        .doc(member.id)
        .set({
      'name': member.name,
      'relationship': member.relationship,
      'fin': member.fin,
      'photo': member.photo,
      'lastSynced': FieldValue.serverTimestamp(),
    });
  }

  // Fetch from cloud
  Stream<List<FamilyMember>> watchFamily(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('family')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FamilyMember(
                  id: doc.id,
                  name: doc['name'],
                  relationship: doc['relationship'],
                  fin: doc['fin'],
                  photo: doc['photo'],
                ))
            .toList());
  }
}
