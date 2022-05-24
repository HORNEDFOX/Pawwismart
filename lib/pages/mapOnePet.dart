import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:pawwismart/bloc/petBloc/pet_bloc.dart';
import 'package:pawwismart/data/repositories/pet_repository.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../bloc/fence/fence_bloc.dart';
import '../data/model/fence.dart';
import '../data/model/pet.dart';
import '../data/repositories/fence_repository.dart';
import 'mapFence.dart';

class MapOnePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapOnePage();
  }
}

class _MapOnePage extends State<MapOnePage> {
  late MapController _mapController;
  double currentZoom = 15.0;
  var index;
  String address = "Searh";
  List<LatLng> polyline = [];

  @override
  void initState() {
    _mapController = MapController();
    //_mapController.move(_mapController.center, currentZoom);
    super.initState();
    debugPrint("${Color.fromRGBO(67, 86, 23, 1).value}");
  }

  Widget build(BuildContext context) {
    index = ModalRoute.of(context)!.settings.arguments as int;
    return RepositoryProvider(
      create: (context) => PetRepository(),
      child: BlocProvider(
        create: (context) => PetBloc(
          petRepository: PetRepository(),
        )..add(LoadPet()),
        child: RepositoryProvider(
          create: (context) => FenceRepository(),
          child: BlocProvider(
            create: (context) => FenceBloc(
              fenceRepository: FenceRepository(),
            ),
            child: BlocBuilder<PetBloc, PetState>(builder: (context, state) {
              if (state is PetLoaded) {
                BlocProvider.of<FenceBloc>(context).add(LoadFence(
                    FirebaseAuth.instance.currentUser!.uid,
                    state.pets.elementAt(index).id!));
                return Scaffold(
                  body: BlocBuilder<FenceBloc, FenceState>(
                      builder: (context, stateFence) {
                    if (stateFence is FenceLoaded) {
                      for (var fence in stateFence.fence) {
                        bool result = _checkIfValidMarker(
                            LatLng(state.pets.elementAt(index).latitude!,
                                state.pets.elementAt(index).longitude!),
                            fence.getLatLng());
                        debugPrint("${fence.name}: ${result}");
                      }
                      return Stack(
                        children: [
                          FlutterMap(
                            mapController: _mapController,
                            options: MapOptions(
                              controller: _mapController,
                              center: LatLng(
                                  state.pets.elementAt(index).latitude!,
                                  state.pets.elementAt(index).longitude!),
                              interactiveFlags: InteractiveFlag.pinchZoom |
                                  InteractiveFlag.drag,
                              zoom: currentZoom,
                              minZoom: 2,
                              maxZoom: 17,
                            ),
                            layers: [
                              TileLayerOptions(
                                urlTemplate:
                                    'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png',
                                retinaMode: true,
                                subdomains: ['a', 'b', 'c'],
                              ),
                              PolygonLayerOptions(
                                polygons: List<Polygon>.generate(
                                    stateFence.fence.length, (int index) {
                                  return Polygon(
                                    points: stateFence.fence
                                        .elementAt(index)
                                        .getLatLng(),
                                    color: stateFence.fence
                                        .elementAt(index)
                                        .color
                                        .withOpacity(0.2),
                                    borderStrokeWidth: 6,
                                    borderColor:
                                        stateFence.fence.elementAt(index).color,
                                  );
                                }).toList(),
                              ),
                              MarkerLayerOptions(
                                markers: [
                                  Marker(
                                    width: 180,
                                    height: 80.0,
                                    point: LatLng(
                                        state.pets.elementAt(index).latitude!,
                                        state.pets.elementAt(index).longitude!),
                                    builder: (ctx) => Container(
                                      //padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
                                        child: Column(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/images/map.svg"),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                            "${state.pets.elementAt(index).name}",
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  74, 85, 104, 1),
                                              letterSpacing: 0.2,
                                              fontSize: 18,
                                              fontFamily: 'Open Sans',
                                              fontWeight: FontWeight.w500,
                                            )),
                                      ],
                                    )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SafeArea(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(15, 20, 15, 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            height: 48,
                                            width: 48,
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 0.9),
                                              borderRadius:
                                                  BorderRadius.circular(12),
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
                                                                const EdgeInsets
                                                                    .all(0),
                                                            child: SvgPicture
                                                                .asset(
                                                              "assets/images/close.svg",
                                                              color: Color
                                                                  .fromRGBO(
                                                                      74,
                                                                      85,
                                                                      104,
                                                                      1),
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            )),
                                        Container(
                                          child: Row(
                                            children: [
                                              Container(
                                                  height: 48,
                                                  width: 48,
                                                  decoration: BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 0.9),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
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
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                          height: 24,
                                                          width: 24,
                                                          child: ClipRRect(
                                                            child: Material(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      0),
                                                              child: InkWell(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(0),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "assets/images/maximize.svg",
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            74,
                                                                            85,
                                                                            104,
                                                                            1),
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  if (currentZoom < 17)
                                                                    _mapController.move(
                                                                        _mapController
                                                                            .center,
                                                                        currentZoom +=
                                                                            1);
                                                                },
                                                              ),
                                                            ),
                                                          )),
                                                    ],
                                                  )),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                  height: 48,
                                                  width: 48,
                                                  decoration: BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 0.9),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
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
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                          height: 24,
                                                          width: 24,
                                                          child: ClipRRect(
                                                            child: Material(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      0),
                                                              child: InkWell(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(0),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "assets/images/minimize.svg",
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            74,
                                                                            85,
                                                                            104,
                                                                            1),
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  if (currentZoom >
                                                                      2)
                                                                    _mapController.move(
                                                                        _mapController
                                                                            .center,
                                                                        currentZoom -=
                                                                            1);
                                                                },
                                                              ),
                                                            ),
                                                          )),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                            height: 48,
                                            width: 48,
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 0.9),
                                              borderRadius:
                                                  BorderRadius.circular(12),
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
                                                                const EdgeInsets
                                                                    .all(0),
                                                            child: SvgPicture
                                                                .asset(
                                                              "assets/images/save_zone.svg",
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        MapPage(
                                                                  lat: state
                                                                      .pets
                                                                      .elementAt(
                                                                          index)
                                                                      .latitude!,
                                                                  lng: state
                                                                      .pets
                                                                      .elementAt(
                                                                          index)
                                                                      .longitude!,
                                                                  zoom:
                                                                      _mapController
                                                                          .zoom,
                                                                  lenghtFence:
                                                                      stateFence
                                                                          .fence
                                                                          .length,
                                                                          createNoPets: false,
                                                                          isEdit: false,
                                                                          pet: state.pets.elementAt(index).id,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                            height: 48,
                                            width: 48,
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 0.9),
                                              borderRadius:
                                                  BorderRadius.circular(12),
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
                                                                const EdgeInsets
                                                                    .all(0),
                                                            child: SvgPicture
                                                                .asset(
                                                              "assets/images/locate-current.svg",
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        PetCard(
                                          pet: state.pets.elementAt(index),
                                          fence: stateFence.fence,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return Container();
                  }),
                );
              }
              return Container();
            }),
          ),
        ),
      ),
    );
  }
}

class PetCard extends StatefulWidget {
  Pet pet;
  List<Fence> fence;

  PetCard({required this.pet, required this.fence});

  @override
  _PetCardState createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
  String _currentAddress = "Not Found";

  Future<void> _getAddressFromLatLng() async {
    await placemarkFromCoordinates(widget.pet.latitude!, widget.pet.longitude!,
            localeIdentifier: "EN")
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = '${place.street}, ${place.country}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    _getAddressFromLatLng();
    return Card(
      //margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
      color: Color.fromRGBO(255, 255, 255, 0.9),
      elevation: 5.0,
      shadowColor: Color.fromRGBO(148, 161, 187, 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        margin: EdgeInsets.fromLTRB(20, 15, 15, 5),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.9),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(148, 161, 187, 0.2),
                              spreadRadius: 1,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/images/batteryLight.svg"),
                            SizedBox(
                              height: 3,
                            ),
                            Text("50%"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        margin: EdgeInsets.fromLTRB(25, 5, 15, 15),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.9),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(148, 161, 187, 0.2),
                              spreadRadius: 1,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/images/NSLight.svg"),
                            SizedBox(
                              height: 3,
                            ),
                            Text("100%"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
              height: 90,
              width: 1,
              child: VerticalDivider(),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 24.0,
                          backgroundImage:
                              NetworkImage(widget.pet.image.toString()),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.25,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.pet.name,
                                style: TextStyle(
                                  color: Color.fromRGBO(74, 85, 104, 1),
                                  fontSize: 19,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w900,
                                )),
                            Text(
                                _currentAddress +
                                    " " +
                                    timeago.format(widget.pet.time!),
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Color.fromRGBO(79, 79, 79, 1),
                                  fontSize: 14,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w400,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Virtual Fence " + widget.fence.length.toString(),
                      style: TextStyle(
                        color: Color.fromRGBO(148, 161, 187, 1),
                        fontSize: 16,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 20,
                    width: 230,
                    child: ListView.builder(
                        itemCount: widget.fence.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.fromLTRB(10, 3, 10, 0),
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                                color: widget.fence.elementAt(index).color,
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              widget.fence.elementAt(index).name,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool _checkIfValidMarker(LatLng tap, List<LatLng> vertices) {
  int intersectCount = 0;
  for (int j = 0; j < vertices.length - 1; j++) {
    if (rayCastIntersect(tap, vertices[j], vertices[j + 1])) {
      intersectCount++;
    }
  }

  return ((intersectCount % 2) == 1); // odd = inside, even = outside;
}

bool rayCastIntersect(LatLng tap, LatLng vertA, LatLng vertB) {
  double aY = vertA.latitude;
  double bY = vertB.latitude;
  double aX = vertA.longitude;
  double bX = vertB.longitude;
  double pY = tap.latitude;
  double pX = tap.longitude;

  if ((aY > pY && bY > pY) || (aY < pY && bY < pY) || (aX < pX && bX < pX)) {
    return false; // a and b can't both be above or below pt.y, and a or
    // b must be east of pt.x
  }

  if (aX == bX) {
    return true;
  }
  double m = (aY - bY) / (aX - bX); // Rise over run
  double bee = (-aX) * m + aY; // y = mx + b
  double x = (pY - bee) / m; // algebra is neat!

  return x > pX;
}
