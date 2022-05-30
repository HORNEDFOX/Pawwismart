import '../model/pet.dart';

abstract class BasePetRepository{
  Stream<List<Pet>> getPet();
  Future<void> createPet(Pet pet);
  Future<void> updatePet(Pet pet);
  Future<void> updatePetPictures(Pet pet, String imageName);
  Future<void> deletePet(Pet pet);
  Future<void> sharePet(Pet pet, String User);
  Future<void> removeSharePet(Pet pet, String User);
  Future<void> updatePetInfo(String id, String name, String image);
  Future<void> updatePetDevice(String id, String device);
}