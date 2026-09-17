import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FavoriteService {
  FavoriteService._();

  static final FavoriteService instance =
  FavoriteService._();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  String get _uid =>
      FirebaseAuth.instance.currentUser!.uid;

  CollectionReference<Map<String, dynamic>>
  get _favorites => _firestore
      .collection("users")
      .doc(_uid)
      .collection("favorites");
  Future<List<String>> getFavorites() async {

    final snapshot = await _favorites.get();

    return snapshot.docs
        .map((doc) => doc.id)
        .toList();

  }
  Future<bool> isFavorite(String title) async {

    final doc =
    await _favorites.doc(title).get();

    return doc.exists;

  }
  Future<void> toggleFavorite(
      String title,
      ) async {

    final doc =
    await _favorites.doc(title).get();

    if (doc.exists) {

      await _favorites.doc(title).delete();

    } else {

      await _favorites.doc(title).set({
        "title": title,
      });

    }

  }
}