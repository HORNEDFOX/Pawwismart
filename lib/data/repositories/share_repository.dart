import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/share.dart';

class ShareRepository {
  final FirebaseFirestore _firebaseFirestore;

  ShareRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Share>> getAllSharePet(String pet) {
    return _firebaseFirestore.collection("Share").where("IDPet", isEqualTo: pet).where("IsActive", isEqualTo: true).snapshots().map((snap) {
      return snap.docs.map((doc) => Share.fromSnapshot(doc)).toList();
    });
  }


  @override
  Future<void> deleteShare(Share share) async {
    return _firebaseFirestore.collection('Share').doc(share.id).update({
      "IsActive": false
    });
  }

  Future<void> deleteShareFriend(String pet, String email) async {
    return _firebaseFirestore.collection("Share").where("IDPet", isEqualTo: pet).where("Email", isEqualTo: email).snapshots().forEach((element) {
      for (var element in element.docs) {
        _firebaseFirestore.collection('Share').doc(element.id).update({
          "IsActive": false
        });
      }
    });
  }

  Future<void> createShare(Share share) async {
    await _firebaseFirestore.collection('Share').doc(share.id).set(share.toMap());
  }
}
