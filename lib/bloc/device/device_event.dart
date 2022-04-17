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
  final Device device;

  UpdateDevice(this.device);

  @override
  List<Object> get props => [device];
}

class UpdateIDDevice extends DeviceEvent{
  final String device;
  final bool state;

  UpdateIDDevice(this.device, this.state);

  @override
  List<Object> get props => [device];
}