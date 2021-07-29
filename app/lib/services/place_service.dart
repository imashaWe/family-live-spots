import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_live_spots/models/place.dart';
import 'package:family_live_spots/services/auth_service.dart';
import 'package:family_live_spots/utility/env.dart';
import 'package:family_live_spots/utility/functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class PlaceService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future searchLoction(String q) async {
    var url = Uri.parse(ENV.GOOGLE_MAP_URL +
        'place/findplacefromtext/json?input=$q&fields=formatted_address,name,geometry&inputtype=textquery&key=${ENV.GOOGLE_API_KEY}');
    final r = await http.get(
      url,
    );
    print(r.statusCode);
    print(jsonDecode(r.body));
  }

  static Future<String> findPlaceByLatLong(LatLng geoPoint) async {
    // https://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&key=YOUR_API_KEY
    try {
      var url = Uri.parse(ENV.GOOGLE_MAP_URL +
          'geocode/json?latlng=${geoPoint.latitude},${geoPoint.longitude}&key=${ENV.GOOGLE_API_KEY}');
      final r = await http.get(
        url,
      );
      if (r.statusCode == 200) {
        final data = jsonDecode(r.body);

        return data['results'][0]['formatted_address'];
      } else {
        throw Exception("Something went wrong");
      }
    } catch (e) {
      throw e;
    }
  }

  static Future addNewPlace(
      {required String name,
      required String address,
      required GeoPoint location,
      required bool isOtherPlace}) async {
    try {
      return await _firestore.collection("Place").add({
        'name': name,
        'address': address,
        'location': location,
        'isOtherPlace': isOtherPlace,
        'uid': AuthService.user!.uid
      });
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  static Future setPlace({
    required int id,
    String? name,
    required String address,
    required GeoPoint location,
  }) async {
    try {
      await _firestore.runTransaction((t) async {
        final userDoc =
            _firestore.collection("User").doc(AuthService.user!.uid);
        final r = await userDoc.get();
        List places = r.data()!['places'];

        places[id]['name'] = name;
        places[id]['address'] = address;
        places[id]['location'] = location;
        return t.update(userDoc, {'places': places});
      });
    } on FirebaseException catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<Place> getPlaceByName({String? name}) async {
    try {
      Query q;
      if (name == null)
        q = _firestore
            .collection("Place")
            .where('uid', isEqualTo: AuthService.user!.uid)
            .where('isOtherPlace', isEqualTo: true);
      else
        q = _firestore
            .collection("Place")
            .where('uid', isEqualTo: AuthService.user!.uid)
            .where('name', isEqualTo: name);
      final r = await q.limit(1).get();
      if (r.docs.isEmpty) throw Exception("No matcing recoad!");
      return Place.fromJson(parseDataWithID(r.docs.first));
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  static Future<List<Place>> getUserPlacess() async {
    final r = await _firestore
        .collection("Place")
        .where('uid', isEqualTo: AuthService.user!.uid)
        .get();
    return r.docs.map((e) => Place.fromJson(parseDataWithID(e))).toList();
  }
}
