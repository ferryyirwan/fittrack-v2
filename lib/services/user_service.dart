import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';

class UserService {
  UserService._();

  static final UserService instance = UserService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  Future<void> createUser(AppUser user) async {
    await _users.doc(user.uid).set(user.toMap());
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();

    if (!doc.exists) return null;

    return AppUser.fromMap(doc.data()!);
  }

  Stream<AppUser?> streamUser(String uid) {
    return _users.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;

      return AppUser.fromMap(doc.data()!);
    });
  }

  Future<void> updateUser(AppUser user) async {
    await _users.doc(user.uid).update(user.toMap());
  }

  Future<void> updateProfileImage(String imageUrl) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await _users.doc(uid).update({
      "profileImageUrl": imageUrl,
    });
  }

  Future<void> incrementWorkoutStreak() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await _users.doc(uid).get();

    if (!doc.exists) return;

    final data = doc.data()!;

    final currentStreak = data["workoutStreak"] ?? 0;

    await _users.doc(uid).update({
      "workoutStreak": currentStreak + 1,
    });
  }

  Future<void> updateWorkoutStreak({
    required int streak,
    required DateTime lastWorkoutDate,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await _users.doc(uid).update({
      "workoutStreak": streak,
      "lastWorkoutDate":
      lastWorkoutDate.toIso8601String(),
    });
  }
}