import '../model/pet.dart';

abstract class BasePetRepository{
  Stream<List<Pet>> getAllPet();
  Future<void> createPet(Pet pet);
  Future<void> updatePet(Pet pet);
  Future<void> updatePetPictures(Pet pet, String imageName);
  Future<void> deletePet(Pet pet);
}