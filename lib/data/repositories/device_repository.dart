import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/device.dart';

class DeviceRepository {
  final FirebaseFirestore _firebaseFirestore;

  DeviceRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<Device> getDevice(String QRCode) {
    return _firebaseFirestore
        .collection('Device')
        .doc(QRCode)
        .snapshots()
        .map((snap) => Device.fromSnapshot(snap));
  }

  Future<void> updateIDDevice(String device, bool state) async {
    return _firebaseFirestore.collection('Device').doc(device).update({
      'IsBusy': state
    });
  }
}
