import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pawwismart/data/repositories/device_repository.dart';

import '../../data/model/device.dart';

part 'device_state.dart';

part 'device_event.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final DeviceRepository _deviceRepository;
  StreamSubscription? _deviceSubscription;

  DeviceBloc({required DeviceRepository deviceRepository})
      : _deviceRepository = deviceRepository,
        super(DeviceLoading()) {
    on<LoadDevice>(_onLoadDevice);
    on<UpdateDevice>(_onUpdateDevice);
    on<UpdateIDDevice>(_onUpdateIDDevice);
  }

  void _onLoadDevice(LoadDevice event, Emitter<DeviceState> emit) {
    try {
      _deviceSubscription?.cancel();
      _deviceSubscription = _deviceRepository.getDevice(event.QRCode).listen(
              (device) => add(UpdateDevice(device)));
    } catch (e) {
      emit(DeviceNoLoading());
    }
  }

  void _onUpdateDevice(UpdateDevice event, Emitter<DeviceState> emit) {
    if(event.device.isBusy != true){
    emit(DeviceLoaded(device: event.device));
    }
    else emit(DeviceNoLoading());
  }

  void _onUpdateIDDevice(UpdateIDDevice event, Emitter<DeviceState> emit) {
    _deviceRepository.updateIDDevice(event.device, event.state);
  }
}
