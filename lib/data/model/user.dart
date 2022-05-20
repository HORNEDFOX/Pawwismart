import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;

  const User(
      {required this.id,
        required this.name,
        required this.email,});

  @override
  // TODO: implement props
  List<Object> get props => [id, name, email];

  @override
  String toString() {
    return 'PetEntity { id: $id, name: $name, email: $email}';
  }

  static User fromSnapshot(DocumentSnapshot snap) {
    User user = User(
        id: snap.id,
        name: snap['Name'],
        email: snap['Email']);
    return user;
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Email': email,
    };
  }
}
