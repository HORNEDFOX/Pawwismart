part of 'pet_bloc.dart';

abstract class PetEvent extends Equatable{
  const PetEvent();

  @override
  List<Object> get props => [];
}

class LoadPet extends PetEvent{}

class UpdatePet extends PetEvent{
  final List<Pet> pets;

  UpdatePet(this.pets){}

  @override
  List<Object> get props => [pets];
}