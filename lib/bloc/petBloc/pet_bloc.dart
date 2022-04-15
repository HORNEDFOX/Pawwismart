import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pawwismart/data/repositories/pet_repository.dart';

import '../../data/model/pet.dart';

part 'pet_state.dart';
part 'pet_event.dart';

class PetBloc extends Bloc<PetEvent, PetState> {
  final PetRepository _petRepository;
  StreamSubscription? _petSubscription;

  PetBloc({required PetRepository petRepository})
      : _petRepository = petRepository,
        super(PetLoading()) {
    on<LoadPet>(_onLoadPets);
    on<UpdatePet>(_onUpdatePets);
    on<DeletePet>(_onDeletePet);
    on<AddPet>(_onAddPet);
    on<CreatingPet>(_onCreatingPet);
  }

  void _onLoadPets(LoadPet event, Emitter<PetState> emit) {
    _petSubscription?.cancel();
    _petSubscription = _petRepository.getAllPet().listen(
          (pet) => add(UpdatePet(pet),
    ),
    );
  }

  void _onUpdatePets(UpdatePet event, Emitter<PetState> emit) {
    emit(PetLoaded(pets: event.pets));
  }

  void _onDeletePet(DeletePet event, Emitter<PetState> emit)  {
    _petSubscription?.cancel();
    _petSubscription = _petRepository.deletePet(event.pet) as StreamSubscription?;
    LoadPet();
  }

  void _onAddPet(AddPet event, Emitter<PetState> emit)  {
    _petRepository.createPet(event.pet);
  }

  void _onCreatingPet(CreatingPet event, Emitter<PetState> emit) {
    emit(PetCreating());
  }
}