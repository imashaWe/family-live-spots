import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:google_maps_flutter/google_maps_flutter.dart';

Map<String, dynamic> parseDataWithID(dynamic q) {
  var data = q.data();
  data!['id'] = q.id;
  return data;
}

LatLng parseLatLng(GeoPoint point) => LatLng(point.latitude, point.longitude);
LatLng parseLatLngFromCoords(bg.Coords coods) =>
    LatLng(coods.latitude, coods.longitude);
GeoPoint parseGeoPoint(LatLng location) =>
    GeoPoint(location.latitude, location.longitude);
