import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawwismart/data/model/pet.dart';
import 'package:pawwismart/data/repositories/base_pet_repository.dart';
import 'package:pawwismart/data/repositories/storage_repository.dart';

class PetRepository extends BasePetRepository {
  final FirebaseFirestore _firebaseFirestore;

  PetRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Pet>> getAllPet() {
    return _firebaseFirestore.collection("Pet").snapshots().map((snap) {
      return snap.docs.map((doc) => Pet.fromSnapshot(doc)).toList();
    });
  }

  @override
  Future<void> deletePet(Pet pet) async {
    return _firebaseFirestore.collection("Pet").doc('${pet.id}').delete();
  }

  @override
  Future<void> createPet(Pet pet) async {
    await _firebaseFirestore.collection('Pet').doc(pet.id).set(pet.toMap());
  }

  @override
  Future<void> updatePet(Pet pet) async {
    return _firebaseFirestore
        .collection('Pet')
        .doc(pet.id)
        .update(pet.toMap())
        .then(
          (value) => print('Pet document updated.'),
        );
  }

  @override
  Future<void> updatePetPictures(Pet pet, String imageName) async {
    String downloadUrl =
        await StorageRepository().getDownloadURL(pet, imageName);

    return _firebaseFirestore.collection('Pet').doc(pet.id).update({
      'Image': FieldValue.arrayUnion([downloadUrl])
    });
  }
}
