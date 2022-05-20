import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Share extends Equatable {
  final String ? id;
  final String IDUser;
  final String IDPet;
  final String name;
  final String email;
  final DateTime ? date;
  final bool isActive;

  const Share(
      {this.id,
        required this.IDUser,
        required this.IDPet,
        required this.name,
        required this.email,
        required this.isActive,
      this.date});

  @override
  // TODO: implement props
  List<Object> get props => [{id}, IDUser, IDPet, name, email, {date}, isActive];

  @override
  String toString() {
    return 'PetEntity { id: $id, IDUser: $IDUser, IDPet: $IDPet, name: $name, email: $email, is active: $isActive}';
  }

  static Share fromSnapshot(DocumentSnapshot snap) {
    Share share = Share(
        id: snap.id,
        IDUser: snap['IDUser'],
        IDPet: snap['IDPet'],
        name: snap['Name'],
        email: snap['Email'],
        date: DateTime.parse(snap['Date'].toDate().toString()),
        isActive: snap['IsActive']);
    return share;
  }

  Map<String, dynamic> toMap() {
    return {
      'IDUser': IDUser,
      'IDPet': IDPet,
      'Name': name,
      'Email': email,
      "Date": Timestamp.fromDate(date!),
      'IsActive': isActive,
    };
  }
}
