import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawwismart/data/model/pet.dart';
import 'package:pawwismart/data/repositories/storage_repository.dart';

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
}
