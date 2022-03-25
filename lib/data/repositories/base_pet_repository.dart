import '../model/pet.dart';

abstract class BasePetRepository{
  Stream<List<Pet>> getAllPet();
}