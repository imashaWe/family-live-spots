import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_live_spots/models/user_profile.dart';
import 'package:family_live_spots/services/auth_service.dart';
import 'package:family_live_spots/utility/constants.dart';
import 'package:family_live_spots/utility/env.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final _LocationPermisson permisson = _LocationPermisson();

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
    final state = await bg.BackgroundGeolocation.state;
    if (state.enabled) return;

    await bg.BackgroundGeolocation.ready(ENV.BACKGROUD_LOCATION_CONFIG)
        .then((bg.State s) async {
      if (!s.enabled) {
        ////
        // 3.  Start the plugin.
        //
        if (s.trackingMode == 1) {
          bg.BackgroundGeolocation.start();
        } else {
          bg.BackgroundGeolocation.startGeofences();
        }
        //await bg.BackgroundGeolocation.start();
        //await bg.BackgroundGeolocation.startBackgroundTask();
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

  static Future<List<UserLocation>> getUserLocationHistory() async {
    final r = await _firestore
        .collection("Location")
        .where("uid", isEqualTo: AuthService.user!.uid)
        .get();
    return r.docs.map((e) => UserLocation.fromJson(e.data())).toList();
  }

  static void onLocationChange(dynamic Function(bg.Location) success,
          [dynamic Function(bg.LocationError)? failure]) =>
      bg.BackgroundGeolocation.onLocation(success, failure);

  static Future<List<UserLocation>> getUserLocationHistoryByUid(
      String uid) async {
    final r = await _firestore
        .collection("Location")
        .where("uid", isEqualTo: uid)
        .get();
    return r.docs.map((e) => UserLocation.fromJson(e.data())).toList();
  }
}

class _LocationPermisson {
  static late StreamController<LocationPermissons>? _locationPermissionStream;

  Future<bool> get isAllPermissionGranetd async {
    final provideState = await bg.BackgroundGeolocation.providerState;
    print(
        "👉Enabled:${provideState.enabled.toString()}\n👉gps:${provideState.gps.toString()}\n👉status:${provideState.status.toString()}\n");
    return provideState.enabled &&
        provideState.gps &&
        (provideState.status == 3 || provideState.status == 4);
  }

  Stream<LocationPermissons> LocationPermissionSnapshot() {
    // if (_locationPermissionStream == null)
    _locationPermissionStream = StreamController<LocationPermissons>();
    _checkPermision();

    return _locationPermissionStream!.stream;
  }

  Future<void> requestPermisson() async {
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

  Future<void> requestLocationPermission() async {
    await Permission.location.request();
    _checkPermision();
  }

  Future<void> requestBackGroudPermission() async {
    await Permission.locationAlways.request();
    _checkPermision();
  }

  Future<void> requesPhsicalActivityPermission() async {
    await Permission.activityRecognition.request();
    _checkPermision();
  }

  void _checkPermision() async {
    _locationPermissionStream!.add(LocationPermissons(
        background: await Permission.locationAlways.isGranted,
        location: await Permission.location.isDenied,
        physicalActivity: await Permission.activityRecognition.isGranted));
  }
}

class LocationPermissons {
  final bool location;
  final bool background;
  final bool physicalActivity;
  LocationPermissons(
      {required this.location,
      required this.background,
      required this.physicalActivity});
}
