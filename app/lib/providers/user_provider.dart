import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_live_spots/models/user_profile.dart';
import 'package:family_live_spots/services/auth_service.dart';
import 'package:family_live_spots/utility/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserProvide extends ChangeNotifier {
  UserProfile? profile;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> _subscription;
  late StreamSubscription<User?> _userSubsription;
  bool get isLoading => profile == null;

  UserProvide() {
    _initUserLisener(AuthService.user!.uid);
    _initAuthLisener();
  }

  void _initAuthLisener() {
    _userSubsription = _auth.authStateChanges().listen((user) {
      if (user != null) {
        _initUserLisener(user.uid);
      } else {
        profile == null;
        notifyListeners();
      }
    });
  }

  void _initUserLisener(String uid) {
    _subscription =
        _firestore.collection('User').doc(uid).snapshots().listen((e) {
      profile = UserProfile.fromJson(parseDataWithID(e));
    });
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _userSubsription.cancel();
    super.dispose();
  }
}
