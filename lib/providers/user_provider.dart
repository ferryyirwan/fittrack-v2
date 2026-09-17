import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {

  AppUser? _user;

  AppUser? get user => _user;

  Future<void> loadUser() async {

    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return;

    _user = await UserService.instance.getUser(uid);

    notifyListeners();

  }

}