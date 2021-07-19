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
    var url =
        Uri.parse(ENV.GOOGLE_MAP_URL + 'input=$q&key=${ENV.GOOGLE_API_KEY}');
    final r = await http.get(
      url,
    );
    print(r.statusCode);
    print(r.body);
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

  static Future updatePlace({
    required String id,
    required String name,
    required String address,
    required GeoPoint location,
  }) async {
    try {
      return await _firestore
          .collection("Place")
          .doc(id)
          .update({'name': name, 'address': address, 'location': location});
    } on FirebaseException catch (e) {
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
}
