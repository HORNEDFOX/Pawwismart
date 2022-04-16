import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/device.dart';

class DeviceRepository {
  final FirebaseFirestore _firebaseFirestore;

  DeviceRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<List<Device>> getDevice(String QRCode) {
    return _firebaseFirestore
        .collection("Device")
        .where("IDDevice", isEqualTo: QRCode)
        .where("IsBusy", isEqualTo: false)
        .snapshots()
        .map((snap) {
            return snap.docs.map((doc) => Device.fromSnapshot(doc)).toList();
    });
  }

  Future<void> updateIDDevice(String device, bool state) async {
    return _firebaseFirestore.collection('Device').doc(device).update({
      'IsBusy': state
    });
  }
}
