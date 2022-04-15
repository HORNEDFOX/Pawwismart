part of 'device_bloc.dart';

abstract class DeviceState extends Equatable{
  const DeviceState();

  @override
  List<Object> get props => [];
}

class DeviceLoading extends DeviceState{}

class DeviceNoLoading extends DeviceState{
  @override
  List<Object> get props => [1];
}

class DeviceLoaded extends DeviceState{
  final List<Device> device;

  const DeviceLoaded({this.device = const <Device>[]});

  @override
  List<Object> get props => [device];
}