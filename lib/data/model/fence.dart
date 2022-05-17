import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class Fence extends Equatable {
  final String? id;
  final Color color;
  final String IDUser;
  final String name;
  final List<dynamic> latitude;
  final List<dynamic> longitude;

  const Fence(
      {this.id,
      required this.IDUser,
      required this.color,
      required this.name,
      required this.latitude,
      required this.longitude});

  @override
  // TODO: implement props
  List<Object> get props => [
        {id},
        IDUser,
        color,
        name,
        latitude,
        longitude
      ];

  List<LatLng> getLatLng() {
    List<LatLng> polyline = [];
    int m = 0, n = 0;
    while(latitude.length > m) {
      while(longitude.length > n)
      {
        polyline.add(LatLng(latitude[m], longitude[n]));
        m++;
        n++;
      }
    }
    polyline.add(LatLng(latitude[0], longitude[0]));
    print(polyline);
    return polyline;
  }

  static Fence fromSnapshot(DocumentSnapshot snap) {
    Fence fence = Fence(
        id: snap.id,
        IDUser: snap['IDUser'],
        color: Color(int.parse(snap['Color'].toString())).withOpacity(1),
        name: snap['Name'],
        longitude: snap['Longitude'],
        latitude: snap['Latitude']);
    return fence;
  }

  Map<String, dynamic> toMap(String Owner) {
    return {
      'IDUser': Owner,
      'Name': name,
      'Color': color.value,
      'Latitude': latitude,
      'Longitude': longitude,
    };
  }
}
