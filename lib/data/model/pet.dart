import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Pet extends Equatable {
  final String ? id;
  final String name;
  final String image;
  final String IDUser;
  final String IDDevice;
  final double ? latitude;
  final double ? longitude;
  final DateTime ? time;
  final int ? charging;
  final int ? connection;
  final bool isDelete;

  const Pet(
      {this.id,
      required this.name,
      required this.image,
        this.latitude,
        this.longitude,
        this.time,
        this.charging,
        this.connection,
      required this.IDUser,
      required this.IDDevice,
      required this.isDelete});

  @override
  // TODO: implement props
  List<Object> get props => [{id}, name, image, {latitude, longitude, time, charging, connection}, IDUser, IDDevice, isDelete];

  @override
  String toString() {
    return 'PetEntity { id: $id, name: $name, image: $image, latitude: $latitude, longitude: $longitude, IDUser: $IDUser, IDDevice: $IDDevice, is delete: $isDelete}';
  }

  String imageBattery()
  {
    if(this.charging! >= 1 && this.charging! <= 40)
      {
        return 'assets/images/battery40.svg';
      }else if(this.charging! >= 41 && this.charging! <= 60)
        {
          return 'assets/images/battery60.svg';
        }else if(this.charging! >= 61 && this.charging! <= 100)
          {
            return 'assets/images/battery100.svg';
          }
    return 'assets/images/battery40.svg';
  }

  String imageConnection()
  {
    if(this.connection! >= 1 && this.connection! <= 25)
    {
      return 'assets/images/connection1.svg';
    }else if(this.connection! >= 26 && this.connection! <= 50)
    {
      return 'assets/images/connection2.svg';
    }else if(this.connection! >= 51 && this.connection! <= 75)
    {
      return 'assets/images/connection3.svg';
    }else if(this.connection! >= 76 && this.connection! <= 100)
    {
      return 'assets/images/connection4.svg';
    }
    return 'assets/images/connection1.svg';
  }

  static Pet fromSnapshot(DocumentSnapshot snap) {
    Pet pet = Pet(
        id: snap.id,
        name: snap['Name'],
        image: snap['Image'],
        latitude: snap['Latitude'],
        longitude: snap['Longitude'],
        time: DateTime.parse(snap['Time'].toDate().toString()),
        charging: snap['Charging'],
        connection: snap['Connection'],
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
      'Longitude': longitude,
      'Latitude': latitude,
      'Time': Timestamp.fromDate(time!),
      'Charging' : charging,
      'Connection': connection,
      'IsDelete': isDelete,
      'ShareTo': FieldValue.arrayUnion([Owner]),
    };
  }
}
