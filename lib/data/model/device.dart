import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Device extends Equatable {
  final String id;
  final String IDDevice;
  final bool isBusy;

  const Device(
      {required this.id, required this.IDDevice, required this.isBusy});

  @override
  // TODO: implement props
  List<Object> get props => [id, IDDevice, isBusy];

  @override
  String toString() {
    return 'DeviceEntity { id: $id, IDDevice: $IDDevice, is busy: $isBusy}';
  }

  static Device fromSnapshot(DocumentSnapshot snap) {
    Device device =
        Device(id: snap.id, IDDevice: snap['IDDevice'], isBusy: snap['IsBusy']);
    return device;
  }
}
