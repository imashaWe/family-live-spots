import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_live_spots/models/user_profile.dart';
import 'package:family_live_spots/services/auth_service.dart';
import 'package:family_live_spots/utility/functions.dart';

class MemberService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future addMemberByEmail(String email, bool isParent) async {
    try {
      final r = await _firestore
          .collection('User')
          .where('email', isEqualTo: email)
          .get();
      if (r.docs.isEmpty) throw "This email dosen't exist!";
      await addMember(r.docs.first.data()['uid'], isParent);
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  static Future addMember(String memberID, bool isParent) async {
    try {
      await _addMember(AuthService.user!.uid, memberID, isParent);
      await _addMember(memberID, AuthService.user!.uid, !isParent);
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  static Future _addMember(String uid, String memberID, bool isParent) async {
    final user = _firestore.collection('User').doc(uid);
    return await _firestore.runTransaction((t) async {
      final userDoc = await user.get();
      List members = userDoc.data()!['members'] ?? [];
      if (members.indexWhere((e) => e['uid'] == uid) != -1)
        throw "This member already added!";
      members.add({'uid': memberID, 'isParent': isParent});
      return t.update(user, {'members': members});
    });
  }

  static Future<List<UserProfile>> fetchAllMembers() async {
    final user = await AuthService.getProfile();
    if (user.members.isEmpty) return [];

    final res = await _firestore
        .collection('User')
        .where('uid', whereIn: user.members.map((e) => e.uid).toList())
        .get();
    return res.docs
        .map((e) => UserProfile.fromJson(parseDataWithID(e)))
        .toList();
  }

  static Stream<List<UserProfile>> membersSnapshot(List<String> uids) {
    return _firestore
        .collection('User')
        .where('uid', whereIn: uids)
        .snapshots()
        .map((q) => q.docs
            .map((e) => UserProfile.fromJson(parseDataWithID(e)))
            .toList());
  }
}
