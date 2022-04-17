part of 'device_bloc.dart';

abstract class DeviceState extends Equatable{
  const DeviceState();

  @override
  List<Object> get props => [];
}

class DeviceLoading extends DeviceState{}

class DeviceNoLoading extends DeviceState{}

class DeviceLoaded extends DeviceState{
  final Device device;

  const DeviceLoaded({required this.device});

  @override
  List<Object> get props => [device];
}