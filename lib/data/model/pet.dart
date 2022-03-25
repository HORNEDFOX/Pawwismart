import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Pet extends Equatable{
  final int id;
  final String name;
  final String image;
  final String IDUser;
  final bool isDelete;

  const Pet({
    required this.id,
    required this.name,
    required this.image,
    required this.IDUser,
    required this.isDelete,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, image, IDUser, isDelete];

  static Pet fromSnapshot(DocumentSnapshot snap)
  {
    Pet pet = Pet(id: snap['id'], name: snap['Name'], image: snap['Image'], IDUser: snap['IDUser'], isDelete: snap['IsDelete']);
    return pet;
  }
}