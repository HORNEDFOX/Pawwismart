part of 'device_bloc.dart';

abstract class DeviceEvent extends Equatable{
  const DeviceEvent();

  @override
  List<Object> get props => [];
}

class LoadDevice extends DeviceEvent{
  final String QRCode;

  LoadDevice(this.QRCode);
}

class UpdateDevice extends DeviceEvent{
  final List<Device> device;

  UpdateDevice(this.device);

  @override
  List<Object> get props => [device];
}

class UpdateIDDevice extends DeviceEvent{
  final Device device;

  UpdateIDDevice(this.device);

  @override
  List<Object> get props => [device];
}