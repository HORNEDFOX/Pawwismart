import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/fence.dart';

class FenceRepository {
  final FirebaseFirestore _firebaseFirestore;

  FenceRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Fence>> getAllFence(String user, String pet) {
    return _firebaseFirestore.collection("Fence").where("IDUser", isEqualTo: user).where("Pets", arrayContains: pet).snapshots().map((snap) {
      return snap.docs.map((doc) => Fence.fromSnapshot(doc)).toList();
    });
  }

  Stream<List<Fence>> getFences(String user) {
    return _firebaseFirestore.collection("Fence").where("IDUser", isEqualTo: user).snapshots().map((snap) {
      return snap.docs.map((doc) => Fence.fromSnapshot(doc)).toList();
    });
  }

  @override
  Future<void> createFence(Fence fence, List<dynamic> pet) async {
    await _firebaseFirestore.collection('Fence').doc(fence.id).set(fence.toMap(FirebaseAuth.instance.currentUser!.uid, pet));
  }
}