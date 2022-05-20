import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user.dart';

class UserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<User> getUserShare(String email) {
    return _firebaseFirestore
        .collection('User')
        .where("Email", isEqualTo: email)
        .snapshots()
        .map((event) => event.docs.map((e) => User.fromSnapshot(e)).single);
  }
}
