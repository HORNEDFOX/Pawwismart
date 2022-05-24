import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pawwismart/data/repositories/storage_repository.dart';

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
    on<LoadFences>(_onLoadFences);
    on<UpdateFence>(_onUpdateFence);
    on<AddFence>(_onAddFence);
    on<AddPetsFence>(_onAddPetsFence);
    on<DeletePetsFence>(_onDeletePetsFence);
    on<DeleteFence>(_onDeleteFence);
    on<DeleteFenceWithDeletePet>(_onDeleteFenceWithDeletePet);
    on<DeleteFenceNull>(_onDeleteFenceNull);
    on<EditFence>(_onEditFence);
  }

  void _onLoadFence(LoadFence event, Emitter<FenceState> emit) {
    _fenceSubscription?.cancel();
    _fenceSubscription = _fenceRepository.getAllFence(event.user, event.pet).listen(
          (fence) => add(UpdateFence(fence),
      ),
    );
  }

  void _onLoadFences(LoadFences event, Emitter<FenceState> emit) {
    _fenceSubscription?.cancel();
    _fenceSubscription = _fenceRepository.getFences(event.user).listen(
          (fence) => add(UpdateFence(fence),
      ),
    );
  }

  void _onUpdateFence(UpdateFence event, Emitter<FenceState> emit) {
    emit(FenceLoaded(fence: event.fence));
  }

  void _onAddFence(AddFence event, Emitter<FenceState> emit)  {
    _fenceRepository.createFence(event.fence, event.pet);
  }

  void _onAddPetsFence(AddPetsFence event, Emitter<FenceState> emit)  {
    _fenceRepository.addPetsFence(event.pet, event.fence);
  }

  void _onDeletePetsFence(DeletePetsFence event, Emitter<FenceState> emit)  {
    _fenceRepository.deletePetsFence(event.pet, event.fence);
  }

  void _onDeleteFence(DeleteFence event, Emitter<FenceState> emit)  {
    _fenceRepository.deleteFence(event.fence);
  }

  void _onDeleteFenceWithDeletePet(DeleteFenceWithDeletePet event, Emitter<FenceState> emit)  {
    _fenceRepository.deleteFenceWithDeletePet(event.pet);
  }

  void _onDeleteFenceNull(DeleteFenceNull event, Emitter<FenceState> emit)  {
    _fenceRepository.deleteNullFence();
  }

  void _onEditFence(EditFence event, Emitter<FenceState> emit)  {
    _fenceRepository.updateFence(event.fence, event.id);
  }
}