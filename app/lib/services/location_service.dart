import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_live_spots/models/user_profile.dart';
import 'package:family_live_spots/services/auth_service.dart';
import 'package:family_live_spots/utility/constants.dart';
import 'package:family_live_spots/utility/env.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class LocationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static Future syncMyCurrentLocation() async {
    try {
      final l = await bg.BackgroundGeolocation.getCurrentPosition();
      await _firestore
          .collection("User")
          .doc(AuthService.user!.uid)
          .update({'lastLocation': UserLocation.fromCoodrs(l).toJSON});
    } catch (e) {}
  }

  static Future<void> startTracking() async {
    final r = await bg.BackgroundGeolocation.state;
    if (r.enabled) return;
    await bg.BackgroundGeolocation.ready(ENV.BACKGROUD_LOCATION_CONFIG)
        .then((bg.State state) async {
      if (!state.enabled) {
        ////
        // 3.  Start the plugin.
        //
        await bg.BackgroundGeolocation.start();
        await bg.BackgroundGeolocation.startBackgroundTask();
        print("Started location tracking....");
      }
    });
  }

  static Future stopTracking() async {
    final r = await bg.BackgroundGeolocation.state;
    if (!r.enabled) return;
    await bg.BackgroundGeolocation.stop();
  }

  static Future sync() async {
    try {
      await bg.BackgroundGeolocation.sync();
    } catch (e) {
      print(e);
    }
  }

  static Future<bg.ProviderChangeEvent> get state async =>
      await bg.BackgroundGeolocation.providerState;

  static Future requestPermisson() async {
    await bg.BackgroundGeolocation.setConfig(bg.Config(
        locationAuthorizationRequest: 'Always',
        backgroundPermissionRationale: bg.PermissionRationale(
            title:
                "Allow ${Constans.APP_NAME} to access this device's location even when closed or not in use.",
            message:
                "In order to track your activity in the background, please enable Always location permission",
            positiveAction: "Change to Always",
            negativeAction: "Cancel")));
    await bg.BackgroundGeolocation.requestPermission();
  }

  static Future<List<UserLocation>> getUserLocationHistory() async {
    final r = await _firestore
        .collection("Location")
        .where("uid", isEqualTo: AuthService.user!.uid)
        .get();
    return r.docs.map((e) => UserLocation.fromJson(e.data())).toList();
  }

  static Future<List<UserLocation>> getUserLocationHistoryByUid(
      String uid) async {
    final r = await _firestore
        .collection("Location")
        .where("uid", isEqualTo: uid)
        .get();
    return r.docs.map((e) => UserLocation.fromJson(e.data())).toList();
  }
}
