import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:pawwismart/pages/toastWidget.dart';

import '../bloc/fence/fence_bloc.dart';
import '../bloc/petBloc/pet_bloc.dart';
import '../data/model/fence.dart';
import '../data/repositories/fence_repository.dart';
import '../data/repositories/pet_repository.dart';
import 'inputValidationMixin.dart';

class MarkerNotifier extends ChangeNotifier {
  Color currentColor = Color.fromRGBO(151, 196, 232, 1);

  List<Marker> markers = [];
  List<LatLng> polyline = [];

  addNewMarker({required LatLng kLatLang}) {
    markers.add(Marker(
        point: kLatLang,
        builder: (context) {
          return GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  new SnackBar(content: Text('Marker is clicked')));
            },
            child: CircleAvatar(
              backgroundColor: currentColor,
              radius: 50,
            ),
          );
        }));
    polyline.add(kLatLang);
    notifyListeners();
  }

  setColor({required Color color}) {
    currentColor = color;
  }

  clearAllMarkers() {
    markers.clear();
    polyline.clear();
    notifyListeners();
  }

  deleteMarkers() {
    if (markers.isNotEmpty) {
      markers.removeAt(markers.length - 1);
      polyline.removeAt(polyline.length - 1);
      notifyListeners();
    }
  }
}

class MapPage extends StatefulWidget {
  double lat, lng, zoom;
  int lenghtFence;
  bool createNoPets;
  bool isEdit;
  List<LatLng>? latLng;
  Color? color;
  String? nameFence;
  List<dynamic>? pet;
  String? fenceId;

  MapPage(
      {required this.lat,
      required this.lng,
      required this.zoom,
      required this.lenghtFence,
      required this.createNoPets,
      required this.isEdit,
      this.latLng,
      this.color,
      this.nameFence,
      this.pet,
      this.fenceId});

  @override
  State<StatefulWidget> createState() {
    return _MapPage();
  }
}

class _MapPage extends State<MapPage> with InputValidationMixin {
  late MapController mapController;
  late MarkerNotifier markerNotifier = MarkerNotifier();
  late String nameFence = widget.lenghtFence != 0
      ? "Fence " + (widget.lenghtFence + 1).toString()
      : "Fence";
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Color currentColor = Color.fromRGBO(151, 196, 232, 1);

  void changeColor(Color color) => setState(() {
        currentColor = color;
        markerNotifier.setColor(color: color);
      });

  @override
  void initState() {
    mapController = MapController();
    if (widget.isEdit) {
      for (int i = 0; i < widget.latLng!.length - 1; i++) {
        markerNotifier.addNewMarker(kLatLang: widget.latLng!.elementAt(i));
      }
      currentColor = widget.color!;
      nameFence = widget.nameFence!;
      markerNotifier.currentColor = widget.color!;
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => FenceRepository(),
      child: BlocProvider(
        create: (context) => FenceBloc(
          fenceRepository: FenceRepository(),
        )..add(LoadFences(FirebaseAuth.instance.currentUser!.uid)),
        child: BlocBuilder<FenceBloc, FenceState>(builder: (context, state) {
          if (state is FenceLoaded) {
            return Scaffold(
              body: Stack(
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      onTap: (pos, val) {
                        setState(
                          () {
                            markerNotifier.addNewMarker(kLatLang: val);
                            print(markerNotifier.markers);
                          },
                        );
                      },
                      onMapCreated: (_con) async {},
                      onPositionChanged: (position, isChanged) {},
                      center: LatLng(widget.lat, widget.lng),
                      interactiveFlags:
                          InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                      zoom: widget.zoom,
                      minZoom: 2,
                      maxZoom: 17.0,
                    ),
                    layers: [
                      TileLayerOptions(
                        urlTemplate:
                            'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                        retinaMode: true,
                      ),
                      PolylineLayerOptions(polylines: [
                        Polyline(
                          points: markerNotifier.polyline +
                              markerNotifier.polyline.map((e) => e).toList(),
                          color: currentColor,
                          strokeWidth: 6,
                        )
                      ]),
                      MarkerLayerOptions(
                        markers: markerNotifier.markers,
                        rotate: false,
                      ),
                    ],
                  ),
                  SafeArea(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(15, 20, 15, 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 0.9),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromRGBO(
                                              148, 161, 187, 0.2),
                                          spreadRadius: 1,
                                          blurRadius: 20,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            height: 24,
                                            width: 24,
                                            child: ClipRRect(
                                              child: Material(
                                                color: const Color.fromRGBO(
                                                    255, 255, 255, 0),
                                                child: InkWell(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    child: SvgPicture.asset(
                                                      "assets/images/close.svg",
                                                      color:
                                                          const Color.fromRGBO(
                                                              74, 85, 104, 1),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                            )),
                                      ],
                                    )),
                                Container(
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  height: 48,
                                  width: 240,
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 0.9),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color.fromRGBO(148, 161, 187, 0.2),
                                        spreadRadius: 1,
                                        blurRadius: 20,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Text(
                                          nameFence.toString(),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color:
                                                Color.fromRGBO(74, 85, 104, 1),
                                            fontFamily: 'Open Sans',
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.4,
                                          ),
                                        ),
                                      ),
                                      Container(
                                          height: 24,
                                          width: 24,
                                          child: ClipRRect(
                                            child: Material(
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 0),
                                              child: InkWell(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  child: SvgPicture.asset(
                                                    "assets/images/menu.svg",
                                                    color: Color.fromRGBO(
                                                        74, 85, 104, 1),
                                                  ),
                                                ),
                                                onTap: () {
                                                  _renameFence();
                                                },
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              titlePadding:
                                                  const EdgeInsets.all(5.0),
                                              contentPadding:
                                                  const EdgeInsets.all(20.0),
                                              content: SingleChildScrollView(
                                                  child: HueRingPicker(
                                                pickerColor: currentColor,
                                                onColorChanged: changeColor,
                                                enableAlpha: false,
                                                displayThumbColor: false,
                                              )));
                                        },
                                      );
                                    });
                                  },
                                  child: Container(
                                    width: 70.0,
                                    height: 70.0,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 0.9),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(
                                              148, 161, 187, 0.2),
                                          spreadRadius: 1,
                                          blurRadius: 20,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/ellipse.svg",
                                          color: currentColor,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text("Color"),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      markerNotifier.deleteMarkers();
                                    });
                                  },
                                  child: Container(
                                    width: 70.0,
                                    height: 70.0,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 0.9),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(
                                              148, 161, 187, 0.2),
                                          spreadRadius: 1,
                                          blurRadius: 20,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/circle-slashed.svg",
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text("Delete"),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      markerNotifier.clearAllMarkers();
                                    });
                                  },
                                  child: Container(
                                    width: 70.0,
                                    height: 70.0,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 0.9),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(
                                              148, 161, 187, 0.2),
                                          spreadRadius: 1,
                                          blurRadius: 20,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/trash.svg",
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text("Clear"),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    if (widget.createNoPets) {
                                      _choicePetsFence(context);
                                    } else {
                                      _createFenceDialog(context);
                                    }
                                  },
                                  child: Container(
                                    width: 70.0,
                                    height: 70.0,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 0.9),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(
                                              148, 161, 187, 0.2),
                                          spreadRadius: 1,
                                          blurRadius: 20,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/check-circle.svg",
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text("Save"),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        }),
      ),
    );
  }

  void _renameFence() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 0,
            backgroundColor: Color(0xffffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 15),
                Text(
                  "Create Name",
                  style: TextStyle(
                    color: Color.fromRGBO(74, 85, 104, 1),
                    fontSize: 23,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 15),
                Form(
                  key: _formKey,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _nameController,
                      obscureText: false,
                      validator: (name) {
                        if (isNameValid(name!))
                          return null;
                        else
                          return 'Enter correct name';
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        labelText: 'Name Fence',
                        labelStyle: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Open Sans',
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w400),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color:  Color.fromRGBO(74, 85, 104, 0.3),),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(151, 196, 232, 1)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(255, 77, 120, 1),),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(255, 77, 120, 1),),
                        ),
                        errorStyle: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Open Sans',
                            color: Color.fromRGBO(255, 77, 120, 1),
                            fontWeight: FontWeight.w300),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Divider(
                  height: 1,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: InkWell(
                    highlightColor: Colors.grey[200],
                    onTap: () {
                      setState(() {
                        if (_formKey.currentState!.validate()) {
                          nameFence = _nameController.text;
                          Navigator.of(context).pop();
                        }
                      });
                    },
                    child: Center(
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Color.fromRGBO(97, 163, 153, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: InkWell(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                    highlightColor: Colors.grey[200],
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _createFenceDialog(context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return Dialog(
            elevation: 0,
            backgroundColor: Color(0xffffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 15),
                Text(!widget.isEdit ? "Create Fence" : "Edit Fence",
                    style: TextStyle(
                      color: Color.fromRGBO(74, 85, 104, 1),
                      fontSize: 23,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w900,
                    )),
                SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 20.0),
                  child: Text(
                      !widget.isEdit ? "Do you really want to create this fence? Make sure you add markers to the map." : "Do you really want to edit this fence? Make sure you add markers to the map."),
                ),
                SizedBox(height: 15),
                Divider(
                  height: 1,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: InkWell(
                    highlightColor: Colors.grey[200],
                    onTap: () {
                      if (markerNotifier.markers.length > 2) {
                        if (!widget.isEdit) {
                          debugPrint("${widget.pet}");
                          _createFence(
                            context,
                            currentColor,
                            markerNotifier.polyline,
                            nameFence,
                            mapController.center.latitude,
                            mapController.center.longitude,
                            mapController.zoom,
                            widget.pet!,
                          );
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        } else {
                          debugPrint("${widget.pet}");
                          _editFence(
                            context,
                            widget.fenceId!,
                            currentColor,
                            markerNotifier.polyline,
                            nameFence,
                            mapController.center.latitude,
                            mapController.center.longitude,
                            mapController.zoom,
                          );
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                      } else
                        {
                          Navigator.of(context).pop();
                          showToast(context, "Incorrect data. A virtual fence must have more than 2 markers.");
                        }
                    },
                    child: Center(
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Color.fromRGBO(97, 163, 153, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: InkWell(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                    highlightColor: Colors.grey[200],
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _choicePetsFence(context) {
    List<dynamic> indexSelect = [];
    List<dynamic> petsSelect = [];
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return StatefulBuilder(builder: (_, setState) {
            return RepositoryProvider(
              create: (context) => PetRepository(),
              child: BlocProvider(
                create: (context) => PetBloc(
                  petRepository: PetRepository(),
                )..add(LoadPet()),
                child: Dialog(
                  elevation: 0,
                  backgroundColor: Color(0xffffffff),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 15),
                      Text(
                        "Select Pets (" + indexSelect.length.toString() + ")",
                        style: TextStyle(
                          color: Color.fromRGBO(74, 85, 104, 1),
                          fontSize: 23,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 15),
                      BlocBuilder<PetBloc, PetState>(builder: (context, state) {
                        if (state is PetLoaded) {
                          return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 20.0),
                                  child: Text(
                                      "Select the pets your want to put into safe zone " +
                                          nameFence +
                                          ":",
                                      style: TextStyle(
                                        color: Color.fromRGBO(79, 79, 79, 1),
                                        fontSize: 14,
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.w400,
                                      )),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 10.0),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    //cacheExtent: 3,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            // Количество элементов горизонтальной оси
                                            crossAxisCount: 4,
                                            // Расстояние по вертикальной оси
                                            mainAxisSpacing: 5.0,
                                            // Расстояние по горизонтальной оси
                                            crossAxisSpacing: 0.0,
                                            // Отношение ширины подкомпонента к высоте
                                            childAspectRatio: 1.0),
                                    scrollDirection: Axis.vertical,
                                    itemCount: state.pets.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        child: InkWell(
                                          splashColor: Colors.white,
                                          onTap: () {
                                            if (!indexSelect.contains(index)) {
                                              indexSelect.add(index);
                                              petsSelect.add(state.pets
                                                  .elementAt(index)
                                                  .id);
                                            } else {
                                              indexSelect.remove(index);
                                              petsSelect.remove(state.pets
                                                  .elementAt(index)
                                                  .id);
                                            }
                                            setState(() {});
                                            debugPrint('Card tapped.');
                                          },
                                          child: Container(
                                            child: Column(
                                              children: <Widget>[
                                                Center(
                                                    child: Container(
                                                        height: 50,
                                                        width: 50,
                                                        child:
                                                            indexSelect
                                                                    .contains(
                                                                        index)
                                                                ? (SizedBox(
                                                                    height: 50,
                                                                    width: 50,
                                                                    child:
                                                                        Stack(
                                                                      clipBehavior:
                                                                          Clip.none,
                                                                      fit: StackFit
                                                                          .expand,
                                                                      children: [
                                                                        CircleAvatar(
                                                                          backgroundImage: NetworkImage(state
                                                                              .pets
                                                                              .elementAt(index)
                                                                              .image),
                                                                        ),
                                                                        Positioned(
                                                                            bottom:
                                                                                0,
                                                                            right:
                                                                                -5,
                                                                            width:
                                                                                22,
                                                                            height:
                                                                                22,
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(color: Color.fromRGBO(97, 163, 153, 1), borderRadius: BorderRadius.circular(20), boxShadow: [
                                                                                BoxShadow(color: Colors.white, spreadRadius: 2),
                                                                              ]),
                                                                              child: SvgPicture.asset(
                                                                                "assets/images/check.svg",
                                                                                color: Colors.white,
                                                                                height: 8,
                                                                              ),
                                                                              alignment: Alignment.center,
                                                                            )),
                                                                      ],
                                                                    ),
                                                                  ))
                                                                : (SizedBox(
                                                                    height: 50,
                                                                    width: 50,
                                                                    child:
                                                                        Stack(
                                                                      clipBehavior:
                                                                          Clip.none,
                                                                      fit: StackFit
                                                                          .expand,
                                                                      children: [
                                                                        CircleAvatar(
                                                                          backgroundImage: NetworkImage(state
                                                                              .pets
                                                                              .elementAt(index)
                                                                              .image),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )))),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  state.pets
                                                      .elementAt(index)
                                                      .name,
                                                  style: TextStyle(
                                                      //color: indexSelect.contains(index) ? Colors.green : Colors.black,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ]);
                        }
                        return Container();
                      }),
                      SizedBox(height: 10),
                      Divider(
                        height: 1,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: InkWell(
                          highlightColor: Colors.grey[200],
                          onTap: () {
                            if (markerNotifier.markers.length > 2)
                              {
                                if (petsSelect.length >= 1) {
                              _createFence(
                                context,
                                currentColor,
                                markerNotifier.polyline,
                                nameFence,
                                mapController.center.latitude,
                                mapController.center.longitude,
                                mapController.zoom,
                                petsSelect,
                              );
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }
                            else{
                              showToast(context, "Incorrect data. Please, select pets.");
                            }
                          } else {
                              Navigator.of(context).pop();
                              showToast(context, "Incorrect data. A virtual fence must have more than 2 markers.");
                            }
                          },
                          child: Center(
                            child: Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Color.fromRGBO(97, 163, 153, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: InkWell(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0),
                          ),
                          highlightColor: Colors.grey[200],
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }
}

void _createFence(context, Color color, List<LatLng> polyline, String name,
    double latCenter, double lngCenter, double zoom, List<dynamic> pet) {
  List<double> lat = [], lng = [];
  for (var marker in polyline) {
    lat.add(marker.latitude);
    lng.add(marker.longitude);
  }
  Fence fence = Fence(
      name: name,
      IDUser: FirebaseAuth.instance.currentUser!.uid,
      color: color,
      latitude: lat,
      isDelete: false,
      longitudeCenter: lngCenter,
      latitudeCenter: latCenter,
      zoom: zoom,
      longitude: lng);
  BlocProvider.of<FenceBloc>(context).add(AddFence(fence, pet));
}

void _editFence(context, String id, Color color, List<LatLng> polyline,
    String name, double latCenter, double lngCenter, double zoom) {
  List<double> lat = [], lng = [];
  for (var marker in polyline) {
    lat.add(marker.latitude);
    lng.add(marker.longitude);
  }
  Fence fence = Fence(
      name: name,
      IDUser: FirebaseAuth.instance.currentUser!.uid,
      color: color,
      latitude: lat,
      isDelete: false,
      longitudeCenter: lngCenter,
      latitudeCenter: latCenter,
      zoom: zoom,
      longitude: lng);
  BlocProvider.of<FenceBloc>(context).add(EditFence(fence, id));
}
