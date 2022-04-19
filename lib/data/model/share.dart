import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:pawwismart/data/model/pet.dart';

class Share extends Equatable {
  final String id;
  final String IDUser;
  final Pet pet;
  final bool isActive;

  const Share(
      {required this.id,
        required this.IDUser,
        required this.pet,
        required this.isActive});

  @override
  // TODO: implement props
  List<Object> get props => [id, IDUser, pet, isActive];

  @override
  String toString() {
    return 'PetEntity { id: $id, IDUser: $IDUser, Pet: $pet, is active: $isActive}';
  }

  static Share fromSnapshot(DocumentSnapshot snap) {
    Share share = Share(
        id: snap.id,
        IDUser: snap['IDUser'],
        pet: snap['IDPet'],
        isActive: snap['IsActive']);
    return share;
  }

  Map<String, dynamic> toMap() {
    return {
      'IDUser': IDUser,
      'IDPet': pet.id,
      'IsActive': isActive,
    };
  }
}
