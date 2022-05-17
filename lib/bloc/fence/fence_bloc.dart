import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/model/fence.dart';
import '../../data/repositories/fence_repository.dart';

part 'fence_state.dart';
part 'fence_event.dart';

class FenceBloc extends Bloc<FenceEvent, FenceState> {
  final FenceRepository _fenceRepository;
  StreamSubscription? _fenceSubscription;

  FenceBloc({required FenceRepository fenceRepository})
      : _fenceRepository = fenceRepository,
        super(FenceLoading()) {
    on<LoadFence>(_onLoadFence);
    on<UpdateFence>(_onUpdateFence);
    on<AddFence>(_onAddFence);
  }

  void _onLoadFence(LoadFence event, Emitter<FenceState> emit) {
    _fenceSubscription?.cancel();
    _fenceSubscription = _fenceRepository.getAllFence(event.user).listen(
          (fence) => add(UpdateFence(fence),
      ),
    );
  }

  void _onUpdateFence(UpdateFence event, Emitter<FenceState> emit) {
    emit(FenceLoaded(fence: event.fence));
  }

  void _onAddFence(AddFence event, Emitter<FenceState> emit)  {
    _fenceRepository.createFence(event.fence);
  }
}