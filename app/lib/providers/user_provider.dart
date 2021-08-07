import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_live_spots/models/user_profile.dart';
import 'package:family_live_spots/services/auth_service.dart';
import 'package:family_live_spots/utility/functions.dart';
import 'package:flutter/cupertino.dart';

class UserProvide extends ChangeNotifier {
  UserProfile? profile;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> _subscription;
  bool get isLoading => profile == null;
  UserProvide() {
    _subscription = _firestore
        .collection('User')
        .doc(AuthService.user!.uid)
        .snapshots()
        .listen((e) {
      profile = UserProfile.fromJson(parseDataWithID(e));
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
