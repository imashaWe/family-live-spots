import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  final String id;
  final String name;
  final String address;
  final GeoPoint location;

  Place({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      location: json['location'],
    );
  }
  LatLng get latLng => LatLng(this.location.latitude, this.location.longitude);
}
