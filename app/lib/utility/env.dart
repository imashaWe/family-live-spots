import 'package:google_maps_flutter/google_maps_flutter.dart';

class ENV {
  static const GOOGLE_MAP_URL =
      "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?";
  static const LOCATION_API =
      "https://us-central1-filtersmusic-d259d.cloudfunctions.net/app/location/add-batch";
  static const DEFAULT_PHOTO_URL =
      "https://firebasestorage.googleapis.com/v0/b/filtersmusic-d259d.appspot.com/o/profile%2Ficons8-male-user-50.png?alt=media&token=ac73ba19-8176-43e0-963a-e84ad0b6e782";

  static const GOOGLE_API_KEY = '_USER_KEY_HERE_';
  static final CameraPosition INITIAL_LOCATION = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
}
