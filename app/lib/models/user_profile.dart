import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? photoURL;
  final List<Member> members;
  final UserLocation? lastLocation;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.members,
    this.lastLocation,
    this.photoURL,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoURL: json['photoURL'],
      lastLocation: json['lastLocation'] != null
          ? UserLocation.fromJson(json['lastLocation'])
          : null,
      members: json['members'] == null
          ? []
          : List<Member>.from(
              json['members'].map((e) => Member.fromJson(e)).toList()),
    );
  }

  // String get title => this
  //     .name
  //     .split(" ")
  //     .map((e) => '${e[0].toUpperCase()}${e.substring(1)}')
  //     .join(" ");
}

class Member {
  final String uid;
  final bool isParent;

  Member({
    required this.uid,
    required this.isParent,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      uid: json['uid'],
      isParent: json['isParent'],
    );
  }
}

class UserLocation {
  final GeoPoint geoPoint;
  final double accuracy;
  final double speed;
  final DateTime dateTime;
  UserLocation(
      {required this.accuracy,
      required this.geoPoint,
      required this.speed,
      required this.dateTime});
  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      accuracy: 0.0,
      geoPoint: json['coords']['geoPoint'],
      speed: json['coords']['speed'],
      dateTime: json['datetime'].toDate(),
    );
  }
  factory UserLocation.fromCoodrs(bg.Location location) {
    return UserLocation(
      accuracy: location.coords.accuracy,
      geoPoint: GeoPoint(location.coords.latitude, location.coords.longitude),
      speed: location.coords.speed,
      dateTime: DateTime.parse(location.timestamp),
    );
  }
  Map<String, dynamic> get toJSON => {
        'accuracy': accuracy,
        'geoPoint': geoPoint,
        'speed': speed,
        'dateTime': dateTime
      };
  LatLng get latLng => LatLng(this.geoPoint.latitude, this.geoPoint.longitude);
}
