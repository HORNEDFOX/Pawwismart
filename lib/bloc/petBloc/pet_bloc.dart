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
  }

  void _onLoadPets(event, Emitter<PetState> emit) {
    _petSubscription?.cancel();
    _petSubscription = _petRepository.getAllPet().listen(
          (pets) => add(UpdatePet(pets),
    ),
    );
  }

  void _onUpdatePets(event, Emitter<PetState> emit) {
    emit(PetLoaded(pets: event.pets));
  }
}