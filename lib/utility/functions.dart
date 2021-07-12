import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, dynamic> parseDataWithID(DocumentSnapshot<Map<String, dynamic>> q) {
  var data = q.data();
  data!['id'] = q.id;
  return data;
}
