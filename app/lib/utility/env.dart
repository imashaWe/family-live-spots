import 'package:google_maps_flutter/google_maps_flutter.dart';

class ENV {
  static const GOOGLE_MAP_URL =
      "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?";
  static const LOCATION_API =
      "https://us-central1-filtersmusic-d259d.cloudfunctions.net/app/location/add-batch";

  static const GOOGLE_API_KEY = 'AIzaSyCY1pALoCUIbruatByXPa-pyPtvNmF4f7o';
  static final CameraPosition INITIAL_LOCATION = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
}
