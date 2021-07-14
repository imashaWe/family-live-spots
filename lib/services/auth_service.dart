import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_live_spots/models/user_profile.dart';
import 'package:family_live_spots/utility/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:apple_sign_in/apple_sign_in.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  static User? get user => _firebaseAuth.currentUser;

  static bool get isLoggedIn => _firebaseAuth.currentUser != null;

  static Future<void> signUp(
      {required String email, required String password}) async {
    try {
      final r = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return await _createNewUserDoc(r.user!.uid);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  static Future<void> forgotPassword({required String email}) async {
    try {
      return await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  static Future<void> editEmail(
      {required String email, required String password}) async {
    try {
      final r = await _firebaseAuth.signInWithEmailAndPassword(
          email: user!.email ?? '', password: password);
      if (r.user != null) {
        return await r.user!.updateEmail(email);
      }
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  static Future<void> editPassword(
      {required String currentPassword, required String newPassword}) async {
    try {
      final r = await _firebaseAuth.signInWithEmailAndPassword(
          email: user!.email ?? '', password: currentPassword);
      if (r.user != null) {
        return await r.user!.updatePassword(newPassword);
      }
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  static Future<bool> signIn(
      {required String email, required String password}) async {
    try {
      final r = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      await _createNewUserDoc(r.user!.uid);
      return r.user != null;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  static Future<void> googleSignUp() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      final googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential r =
          await _firebaseAuth.signInWithCredential(credential);
      if (r != null)
        return await _createNewUserDoc(r.user!.uid);
      else
        throw "Something went wrong!";
    } catch (e) {
      print(e);
      throw 'Something went wrong!';
    }
  }

  static Future<void> appleSignUp({List scopes = const []}) async {
    // if (!await AppleSignIn.isAvailable())
    //   throw "This device doesn't support Apple connect!";
    // try {
    //   final result = await AppleSignIn.performRequests(
    //       [AppleIdRequest(requestedScopes: scopes)]);
    //   final appleIdCredential = result.credential;
    //   final oAuthProvider = OAuthProvider('apple.com');
    //   final credential = oAuthProvider.credential(
    //     idToken: String.fromCharCodes(appleIdCredential.identityToken),
    //     accessToken: String.fromCharCodes(appleIdCredential.authorizationCode),
    //   );
    //   final r = await _firebaseAuth.signInWithCredential(credential);

    //   if (r != null)
    //     return await _createNewUserDoc(r.user!.uid);
    //   else
    throw "Something went wrong!";
    // } catch (e) {
    //   throw "Something went wrong!";
    // }
  }

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
        'email': user!.email,
        'photoURL': user!.photoURL,
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

  static Future<void> _createNewUserDoc(String uid) async {
    final oldUser = await _firestore.collection('User').doc(uid).get();

    if (oldUser.exists) {
      // return await _firestore.collection('User').doc(user!.uid).update({

      // });
    }

    return await _firestore.collection('User').doc(uid).set({
      'uid': uid,
      'createdAt': DateTime.now(),
      'members': [],
      'email': user!.email
    });
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
