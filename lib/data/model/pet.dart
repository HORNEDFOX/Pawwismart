import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Pet extends Equatable {
  final String id;
  final String name;
  final String image;
  final String IDUser;
  final String IDDevice;
  final double ? latitude;
  final double ? longitude;
  final bool isDelete;

  const Pet(
      {required this.id,
      required this.name,
      required this.image,
        this.latitude,
        this.longitude,
      required this.IDUser,
      required this.IDDevice,
      required this.isDelete});

  @override
  // TODO: implement props
  List<Object> get props => [id, name, image, {latitude, longitude}, IDUser, IDDevice, isDelete];

  @override
  String toString() {
    return 'PetEntity { id: $id, name: $name, image: $image, latitude: $latitude, longitude: $longitude, IDUser: $IDUser, IDDevice: $IDDevice, is delete: $isDelete}';
  }

  static Pet fromSnapshot(DocumentSnapshot snap) {
    Pet pet = Pet(
        id: snap.id,
        name: snap['Name'],
        image: snap['Image'],
        latitude: snap['Latitude'],
        longitude: snap['Longitude'],
        IDUser: snap['IDUser'],
        IDDevice: snap['IDDevice'],
        isDelete: snap['IsDelete']);
    return pet;
  }

  Map<String, dynamic> toMap(String Owner) {
    return {
      'Name': name,
      'Image': image,
      'IDUser': IDUser,
      'IDDevice': IDDevice,
      'IsDelete': isDelete,
      'ShareTo': FieldValue.arrayUnion([Owner]),
    };
  }
}
