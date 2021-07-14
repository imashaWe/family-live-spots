import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_live_spots/models/user_profile.dart';
import 'package:family_live_spots/utility/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  static User? get user => _firebaseAuth.currentUser;

  static bool get isLoggedIn => _firebaseAuth.currentUser != null;

  static Future<void> createProfile(
      {required String name, String? imagePath}) async {
    // final res = await _firestore.collection('User').doc(user!.uid).get();
    // if (res.exists) {
    //   res.reference.update({'name': name});
    // }
    try {
      await _firestore.collection('User').doc(user!.uid).set({
        'name': name,
        'uid': user!.uid,
        'createdAt': DateTime.now(),
        'phone': user!.phoneNumber,
        'members': []
      });
      if (imagePath != null) await _uploadPhoto(imagePath);
      return;
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  static Future<void> updateteProfile(
      {required String name, String? imagePath}) async {
    try {
      await _firestore.collection('User').doc(user!.uid).update({'name': name});
      if (imagePath != null) await _uploadPhoto(imagePath);
      return;
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  static Future<void> _uploadPhoto(String path) async {
    try {
      File file = File(path);
      final r =
          await _firebaseStorage.ref('profile/${user!.uid}/').putFile(file);
      final photoUrl = await r.ref.getDownloadURL();
      final userDocs = _firestore.collection('User');
      await userDocs.doc(user!.uid).update({'photoURL': photoUrl});
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<UserProfile> getProfile() async {
    try {
      final r = await _firestore.collection('User').doc(user!.uid).get();
      return UserProfile.fromJson(parseDataWithID(r));
    } catch (e) {
      throw e;
    }
  }

  static Future<void> logout() async {
    try {
      return await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }
}
