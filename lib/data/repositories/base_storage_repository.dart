import '../model/pet.dart';
import 'package:image_picker/image_picker.dart';

abstract class BaseStorageRepository {
  Future<void> uploadImage(Pet pet, XFile image);
  Future<String> getDownloadURL(Pet pet, String imageName);
}