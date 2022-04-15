import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:pawwismart/data/repositories/pet_repository.dart';

import '../model/pet.dart';
import 'base_storage_repository.dart';


class StorageRepository extends BaseStorageRepository {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  @override
  Future<void> uploadImage(Pet pet, XFile image) async {
    try {
      await storage
          .ref('${pet.id}/${image.name}')
          .putFile(
        File(image.path),
      )
          .then(
            (p0) => PetRepository().updatePetPictures(
          pet,
          image.name,
        ),
      );
    } catch (err) {
      print(err);
    }
  }

  @override
  Future<String> getDownloadURL(Pet pet, String imageName) async {
    String downloadURL =
    await storage.ref('${pet.id}/$imageName').getDownloadURL();
    return downloadURL;
  }
}