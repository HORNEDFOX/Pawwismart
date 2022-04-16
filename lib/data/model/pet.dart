import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Pet extends Equatable {
  final String id;
  final String name;
  final String image;
  final String IDUser;
  final String IDDevice;
  final bool isDelete;

  const Pet(
      {required this.id,
      required this.name,
      required this.image,
      required this.IDUser,
      required this.IDDevice,
      required this.isDelete});

  @override
  // TODO: implement props
  List<Object> get props => [id, name, image, IDUser, IDDevice, isDelete];

  @override
  String toString() {
    return 'PetEntity { id: $id, name: $name, image: $image, IDUser: $IDUser, IDDevice: $IDDevice, is delete: $isDelete}';
  }

  static Pet fromSnapshot(DocumentSnapshot snap) {
    Pet pet = Pet(
        id: snap.id,
        name: snap['Name'],
        image: snap['Image'],
        IDUser: snap['IDUser'],
        IDDevice: snap['IDDevice'],
        isDelete: snap['IsDelete']);
    return pet;
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Image': image,
      'IDUser': IDUser,
      'IDDevice': IDDevice,
      'IsDelete': isDelete,
    };
  }
}
