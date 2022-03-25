import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawwismart/data/model/pet.dart';
import 'package:pawwismart/data/repositories/base_pet_repository.dart';

class PetRepository extends BasePetRepository{
  final FirebaseFirestore _firebaseFirestore;

  PetRepository({FirebaseFirestore? firebaseFirestore})
  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Pet>> getAllPet() {
    return _firebaseFirestore
        .collection('Pet')
        .snapshots()
        .map((snap)
        {
          return snap.docs.map((doc) => Pet.fromSnapshot(doc)).toList();
        });
  }
}