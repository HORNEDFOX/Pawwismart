part of 'pet_bloc.dart';

abstract class PetEvent{
  const PetEvent();

  @override
  List<Object> get props => [];
}

class LoadPet extends PetEvent{}

class LoadPetsFence extends PetEvent{
  final List<dynamic> pets;

  LoadPetsFence(this.pets);
}

class CreatingPet extends PetEvent{}

class UpdatePet extends PetEvent{
  final List<Pet> pets;

  UpdatePet(this.pets);

  @override
  List<Object> get props => [pets];
}

class AddPet extends PetEvent {
  final Pet pet;

  const AddPet(this.pet);

  @override
  List<Object> get props => [pet];

  @override
  String toString() => 'Add Pet { record: $pet }';
}

class SharePet extends PetEvent {
  final Pet pet;
  final String User;

  const SharePet(this.pet, this.User);

  @override
  List<Object> get props => [pet];

}

class RemoveSharePet extends PetEvent {
  final Pet pet;
  final String User;

  const RemoveSharePet(this.pet, this.User);

  @override
  List<Object> get props => [pet];

}

class DeletePet extends PetEvent{
  final Pet pet;

  DeletePet(this.pet);

  @override
  List<Object> get props => [pet];
}

class EditPet extends PetEvent{
  final String id;
  final String name;
  final String image;

  EditPet(this.id, this.name, this.image);

  @override
  List<Object> get props => [id, name, image];
}

class EditPetDevice extends PetEvent{
  final String id;
  final String device;

  EditPetDevice(this.id, this.device);

  @override
  List<Object> get props => [id, device];
}