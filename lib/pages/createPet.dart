import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/device/device_bloc.dart';
import '../bloc/petBloc/pet_bloc.dart';
import '../data/model/device.dart';
import '../data/model/pet.dart';
import 'package:pawwismart/pages/inputValidationMixin.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/repositories/device_repository.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with InputValidationMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String Image = "https://firebasestorage.googleapis.com/v0/b/pawwismartdev.appspot.com/o/AvatarDog2.jpg?alt=media&token=3a8d7bdb-fc1a-4c31-aae1-b6f77709a904";

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String QRCode = "";

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        create: (context) => DeviceRepository(),
        child: BlocProvider(
        create: (context) => DeviceBloc(
      deviceRepository: DeviceRepository(),
    ),
    child: Builder(
          builder: (context) {
            return BlocBuilder<DeviceBloc, DeviceState>(
                builder: (context, state) {
              if (state is DeviceLoading) {
                return Container(
                  height: MediaQuery.of(context).size.height / 1.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Ooops!",
                          style: TextStyle(
                            color: Color.fromRGBO(74, 85, 104, 1),
                            fontSize: 30,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w900,
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                          "You have not registered your device.\nTo register the device in the system,\nyou need to scan the QR-Code",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(74, 85, 104, 1),
                            fontSize: 16,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w300,
                          )),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: FlatButton(
                          onPressed: () {
                            scanQR(context);
                          },
                          padding: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color.fromRGBO(151, 196, 232, 1),
                                  Color.fromRGBO(151, 196, 232, 1),
                                  Color.fromRGBO(151, 196, 232, 1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              constraints: BoxConstraints(
                                  minHeight: 30, maxWidth: double.infinity),
                              child: Text(
                                "SCAN QR-CODE",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: FlatButton(
                          onPressed: () {
                            _pressLoadPet(context);
                          },
                          padding: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Color.fromRGBO(151, 196, 232, 1),
                                width: 2,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color.fromRGBO(255, 255, 255, 0),
                                  Color.fromRGBO(255, 255, 255, 0),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              constraints: BoxConstraints(
                                  minHeight: 30, maxWidth: double.infinity),
                              child: Text(
                                "BACK",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(151, 196, 232, 1),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (state is DeviceLoaded) {
                return Container(
                  height: MediaQuery.of(context).size.height / 1.7,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Device Found",
                            style: TextStyle(
                              color: Color.fromRGBO(74, 85, 104, 1),
                              fontSize: 30,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w900,
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                            "Good news, we found your device!\nFill in the following information",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(74, 85, 104, 1),
                              fontSize: 16,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w300,
                            )),
                        SizedBox(
                          height: 25,
                        ),
                        Center(
                          child: CircleAvatar(
                            radius: 80.0,
                            backgroundImage: NetworkImage(Image),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _nameController,
                            obscureText: false,
                            validator: (name) {
                              if (isNameValid(name!))
                                return null;
                              else
                                return 'Enter a valid name';
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 10.0),
                              labelText: 'Name',
                              labelStyle: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Open Sans',
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w400),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(114, 117, 168, 0.5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(151, 196, 232, 1)),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(251, 76, 31, 1)),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(251, 76, 31, 1)),
                              ),
                              errorStyle: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Open Sans',
                                  color: Color.fromRGBO(251, 76, 31, 1),
                                  fontWeight: FontWeight.w300),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: FlatButton(
                            onPressed: () {
                              _createPet(context, state.device);
                            },
                            padding: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color.fromRGBO(151, 196, 232, 1),
                                    Color.fromRGBO(151, 196, 232, 1),
                                    Color.fromRGBO(151, 196, 232, 1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(
                                    minHeight: 30, maxWidth: double.infinity),
                                child: Text(
                                  "CREATE PET",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: FlatButton(
                            onPressed: () {
                              _pressLoadPet(context);
                            },
                            padding: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Color.fromRGBO(151, 196, 232, 1),
                                  width: 2,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color.fromRGBO(255, 255, 255, 0),
                                    Color.fromRGBO(255, 255, 255, 0),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(
                                    minHeight: 30, maxWidth: double.infinity),
                                child: Text(
                                  "BACK",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(151, 196, 232, 1),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (state is DeviceNoLoading) {
                return Container(
                  height: MediaQuery.of(context).size.height / 1.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Device Not Found",
                          style: TextStyle(
                            color: Color.fromRGBO(74, 85, 104, 1),
                            fontSize: 30,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w900,
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                          "This device is not in the list of our\ndevices. If you think an error has\noccurred, please contact support",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(74, 85, 104, 1),
                            fontSize: 16,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w300,
                          )),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: FlatButton(
                          onPressed: () async {
                            await scanQR(context);
                          },
                          padding: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color.fromRGBO(151, 196, 232, 1),
                                  Color.fromRGBO(151, 196, 232, 1),
                                  Color.fromRGBO(151, 196, 232, 1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              constraints: BoxConstraints(
                                  minHeight: 30, maxWidth: double.infinity),
                              child: Text(
                                "SCAN QR-CODE",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: FlatButton(
                          onPressed: () {
                            _pressLoadPet(context);
                          },
                          padding: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Color.fromRGBO(151, 196, 232, 1),
                                width: 2,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color.fromRGBO(255, 255, 255, 0),
                                  Color.fromRGBO(255, 255, 255, 0),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              constraints: BoxConstraints(
                                  minHeight: 30, maxWidth: double.infinity),
                              child: Text(
                                "BACK",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(151, 196, 232, 1),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            });
          },
    ),
        ),
    );
  }

  Future<void> scanQR(context) async {
    try {
      FlutterBarcodeScanner.scanBarcode("#2A99CF", "Cancel", true, ScanMode.QR)
          .then((value) {
        setState(() {
          QRCode = value;
          _pressLoadDevice(context, value);
        });
      });
    } catch (e) {
      setState(() {
        QRCode = "Not";
      });
    }
  }

  void _pressLoadPet(context) {
    BlocProvider.of<PetBloc>(context).add(
      LoadPet(),
    );
  }

  void _pressLoadDevice(context, String code) {
    BlocProvider.of<DeviceBloc>(context).add(
      LoadDevice(code),
    );
  }

  void _createPet(BuildContext context, Device device) {
    if (_formKey.currentState!.validate()) {
      Pet pet = Pet(id: _nameController.text+FirebaseAuth.instance.currentUser!.uid, name: _nameController.text, image: Image.toString(), IDUser: FirebaseAuth.instance.currentUser!.uid, IDDevice: QRCode, isDelete: false);
      BlocProvider.of<PetBloc>(context).add(AddPet(pet));
      BlocProvider.of<DeviceBloc>(context).add(UpdateIDDevice(device.IDDevice, true));
    }
  }
}
