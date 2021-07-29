import 'package:family_live_spots/models/user_profile.dart';
import 'package:family_live_spots/services/auth_service.dart';
import 'package:flutter/cupertino.dart';

class UserProvide extends ChangeNotifier {
  UserProfile? profile;

  bool get isLoading => profile == null;

  void init() {
    AuthService.getProfile().then((p) {
      profile = p;
      notifyListeners();
    });
  }
}
