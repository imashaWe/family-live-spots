import 'package:family_live_spots/services/auth_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

import 'constants.dart';

class ENV {
  static const GOOGLE_MAP_URL = "https://maps.googleapis.com/maps/api/";

  static const LOCATION_API =
      "https://us-central1-filtersmusic-d259d.cloudfunctions.net/app/location/add-batch";

  static const DEFAULT_PHOTO_URL =
      "https://firebasestorage.googleapis.com/v0/b/filtersmusic-d259d.appspot.com/o/profile%2Ficons8-male-user-50.png?alt=media&token=ac73ba19-8176-43e0-963a-e84ad0b6e782";

  static const GOOGLE_API_KEY = '_USER_KEY_HERE_';

  static const SUBSCRIPTION_PLAN_NAME = "fls_premium";

  static final CameraPosition INITIAL_LOCATION = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final MAX_DISTANCE_TWO_POINT = 1000.0;

  static final BACKGROUD_LOCATION_CONFIG = bg.Config(
      url: ENV.LOCATION_API,
      autoSync: true,
      autoSyncThreshold: 5,
      batchSync: true,
      maxBatchSize: 10,
      distanceFilter: 10,
      // headers: {"AUTHENTICATION_TOKEN": "23kasdlfkjlksjflkasdZIds"},
      params: {"uid": AuthService.user!.uid},
      locationsOrderDirection: "DESC",
      maxDaysToPersist: 14,
      locationAuthorizationRequest: 'Always',
      backgroundPermissionRationale: bg.PermissionRationale(
          title:
              "Allow ${Constans.APP_NAME} to access this device's location even when closed or not in use.",
          message:
              "In order to track your activity in the background, please enable Always location permission",
          positiveAction: "Change to Always",
          negativeAction: "Cancel"));
}
