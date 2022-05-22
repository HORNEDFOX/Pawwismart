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
    on<LoadPetsFence>(_onLoadPetsFence);
    on<UpdatePet>(_onUpdatePets);
    on<DeletePet>(_onDeletePet);
    on<AddPet>(_onAddPet);
    on<CreatingPet>(_onCreatingPet);
    on<SharePet>(_onSharePet);
    on<RemoveSharePet>(_onRemoveSharePet);
  }

  void _onLoadPets(LoadPet event, Emitter<PetState> emit) {
    _petSubscription?.cancel();
    _petSubscription = _petRepository.getPet().listen(
          (pet) => add(UpdatePet(pet),
      ),
    );
  }

  void _onLoadPetsFence(LoadPetsFence event, Emitter<PetState> emit) {
    _petSubscription?.cancel();
    _petSubscription = _petRepository.getPetsFence(event.pets).listen(
          (pet) => add(UpdatePet(pet),
      ),
    );
  }

  void _onUpdatePets(UpdatePet event, Emitter<PetState> emit) {
    emit(PetLoaded(pets: event.pets));
  }

  void _onDeletePet(DeletePet event, Emitter<PetState> emit)  {
    _petRepository.deletePet(event.pet);
  }

  void _onAddPet(AddPet event, Emitter<PetState> emit)  {
    _petRepository.createPet(event.pet);
  }

  void _onCreatingPet(CreatingPet event, Emitter<PetState> emit) {
    emit(PetCreating());
  }

  void _onSharePet(SharePet event, Emitter<PetState> emit) {
    _petRepository.sharePet(event.pet, event.User);
  }

  void _onRemoveSharePet(RemoveSharePet event, Emitter<PetState> emit) {
    _petRepository.removeSharePet(event.pet, event.User);
  }
}