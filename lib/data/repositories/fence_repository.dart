import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/fence.dart';

class FenceRepository {
  final FirebaseFirestore _firebaseFirestore;

  FenceRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Fence>> getAllFence(String user, String pet) {
    return _firebaseFirestore.collection("Fence").where("IDUser", isEqualTo: user).where("Pets", arrayContains: pet).where("IsDelete", isEqualTo: false).snapshots().map((snap) {
      return snap.docs.map((doc) => Fence.fromSnapshot(doc)).toList();
    });
  }

  Stream<List<Fence>> getFences(String user) {
    return _firebaseFirestore.collection("Fence").where("IDUser", isEqualTo: user).where("IsDelete", isEqualTo: false).snapshots().map((snap) {
      return snap.docs.map((doc) => Fence.fromSnapshot(doc)).toList();
    });
  }

  @override
  Future<void> createFence(Fence fence, List<dynamic> pet) async {
    await _firebaseFirestore.collection('Fence').doc(fence.id).set(fence.toMap(FirebaseAuth.instance.currentUser!.uid, pet));
  }

  Future<void> addPetsFence(List<dynamic> pet, Fence fence) async {
    return _firebaseFirestore.collection('Fence').doc(fence.id).update({
      "Pets": FieldValue.arrayUnion([...pet])
    });
  }

  Future<void> deletePetsFence(List<dynamic> pet, Fence fence) async {
    return _firebaseFirestore.collection('Fence').doc(fence.id).update({
      "Pets": FieldValue.arrayRemove([...pet])
    });
  }

  Future<void> deleteFence(Fence fence) async {
    return _firebaseFirestore.collection('Fence').doc(fence.id).update({
      "IsDelete": true
    });
  }

  Future<void> deleteFenceWithDeletePet(String pet) async {
    return _firebaseFirestore.collection("Fence").where("Pets", arrayContains: pet).snapshots().forEach((element) {
      for (var element in element.docs) {
        _firebaseFirestore.collection('Fence').doc(element.id).update({
          "Pets": FieldValue.arrayRemove([pet])
        });
      }
    });
  }

  Future<void> deleteNullFence() async {
    return _firebaseFirestore.collection("Fence").where("Pets", isEqualTo: []).snapshots().forEach((element) {
      for (var element in element.docs) {
        _firebaseFirestore.collection('Fence').doc(element.id).update({
          "IsDelete": true
        });
      }
    });
  }

  Future<void> updateFence(Fence fence, String id) async {
    return _firebaseFirestore
        .collection('Fence')
        .doc(id)
        .update(
      {
        'Name': fence.name,
        'Color': fence.color.value,
        'Latitude': fence.latitude,
        'Longitude': fence.longitude,
        'LatitudeCenter': fence.latitudeCenter,
        'LongitudeCenter': fence.longitudeCenter,
        'Zoom': fence.zoom,
      }
    );
  }
}