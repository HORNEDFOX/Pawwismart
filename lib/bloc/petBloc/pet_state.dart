part of 'pet_bloc.dart';

abstract class PetState extends Equatable{
  const PetState();

  @override
  List<Object> get props => [];
}

class PetLoading extends PetState{}

class PetLoaded extends PetState{
  final List<Pet> pets;

  const PetLoaded({this.pets = const <Pet>[]});

  @override
  List<Object> get props => [pets];
}

class PetCreating extends PetState{}