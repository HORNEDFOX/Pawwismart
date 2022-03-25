import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable{
  final String name;
  final String UIDUser;

  const User({
    required this.name,
    required this.UIDUser,
});

  @override
  // TODO: implement props
  List<Object?> get props => [name, UIDUser];

  static User fromSnapshot(DocumentSnapshot snap)
  {
    User user = User(name: snap['Name'], UIDUser: snap['UIDUser']);
    return user;
  }
}