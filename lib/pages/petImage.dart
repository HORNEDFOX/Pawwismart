import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:path_provider/path_provider.dart';

import 'appRoundImage.dart';

class PetImage extends StatefulWidget {
  final Function(String image) onFileChanged;

  PetImage({
    required this.onFileChanged,
  });

  @override
  _PetImageState createState() => _PetImageState();
}

class _PetImageState extends State<PetImage> {
  final ImagePicker _picker = ImagePicker();

  String? image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (image == null)
          Icon(
            Icons.image,
            size: 80,
            color: Colors.indigo,
          ),
        if (image != null)
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => _selectPhoto(),
            child: AppRoundImage.url(
              image!,
              width: 88,
              height: 88,
            ),
          ),
        InkWell(
          onTap: () => _selectPhoto(),
          child: Padding(
            padding: EdgeInsets.all(8.8),
            child: Text(image != null ? 'Change Photo' : 'Select Photo'),
          ),
        )
      ],
    );
  }

  Future _selectPhoto() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) => BottomSheet(
              builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  ListTile(
                      leading: Icon(Icons.camera),
                      title: Text('Camera'),
                      onTap: () {
                        Navigator.of(context).pop();
                        _pickImage(ImageSource.camera);
                      }),
                  ListTile(
                      leading: Icon(Icons.filter),
                      title: Text('Pick a File'),
                      onTap: () {
                        Navigator.of(context).pop();
                        _pickImage(ImageSource.gallery);
                      }),
                ],
              ),
              onClosing: () {},
            ));
  }

  Future _pickImage(ImageSource source) async{
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 50);
    if (pickedFile == null)
      {
        return;
      }

    var file = await ImageCropper().cropImage(sourcePath: pickedFile.path, aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));

    if(file == null){
      return;
    }

    file = await compressImage(file.path, 35);

    await _uploadFile(file.path);
  }

  Future<File> compressImage(String path, int quality) async{
    final newPath = p.join((await getTemporaryDirectory()).path, '${DateTime.now}.${p.extension(path)}');

    final result = await FlutterImageCompress.compressAndGetFile(
      path,
      newPath,
      quality: quality,
    );

    return result!;
  }

  Future _uploadFile(String path) async {
    final ref = storage.FirebaseStorage.instance.ref()
        .child('${DateTime.now().toIso8601String() + p.basename(path)}');

    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();

    setState(() {
      image = fileUrl;
    });

    widget.onFileChanged(fileUrl);
  }
}
