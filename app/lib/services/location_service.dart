import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_live_spots/models/user_profile.dart';
import 'package:family_live_spots/services/auth_service.dart';
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
    await bg.BackgroundGeolocation.ready(bg.Config(
            url: ENV.LOCATION_API,
            autoSync: true,
            autoSyncThreshold: 5,
            batchSync: true,
            maxBatchSize: 10,
            distanceFilter: 10,
            // headers: {"AUTHENTICATION_TOKEN": "23kasdlfkjlksjflkasdZIds"},
            params: {"uid": AuthService.user!.uid},
            locationsOrderDirection: "DESC",
            maxDaysToPersist: 14))
        .then((bg.State state) async {
      if (!state.enabled) {
        ////
        // 3.  Start the plugin.
        //

        await bg.BackgroundGeolocation.start();
        await bg.BackgroundGeolocation.startBackgroundTask();
      }
    });
  }

  static Future stopTracking() async {
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
