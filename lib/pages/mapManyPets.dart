import 'package:avatar_stack/positions.dart';
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

class MapManyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapManyPage();
  }
}

class _MapManyPage extends State<MapManyPage> with TickerProviderStateMixin{
  late MapController _mapController;
  late AnimationController _controller;
  double currentZoom = 15.0;
  List<dynamic> pets = [];
  int index = 0;
  String address = "Searh";
  List<LatLng> polyline = [];
  final settings = RestrictedAmountPositions(
    maxAmountItems: 4,
    maxCoverage: 0.5,
    laying: StackLaying.last,
    minCoverage: 0.2,
  );

  @override
  void initState() {
    _mapController = MapController();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 2),
    )..repeat();
    super.initState();
  }

  Widget _buildBody(String name) {
    return AnimatedBuilder(
      animation: CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildContainer(20 * _controller.value, 1),
            _buildContainer(40 * _controller.value, 2),
            _buildContainer(60 * _controller.value, 3),
            Positioned(
              top: 90,
              child: Container(
                child: Text(name,
                    style: TextStyle(
                      color: Color.fromRGBO(
                          74, 85, 104, 1),
                      letterSpacing: 0.2,
                      fontSize: 18,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w500,
                    )),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContainer(double radius, int circle) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: circle == 1 ? Color.fromRGBO(151, 196, 232, 1).withOpacity(1 - _controller.value/1.5) : Color.fromRGBO(151, 196, 232, 1).withOpacity(1 - _controller.value),
      ),
    );
  }

  Widget build(BuildContext context) {
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
                                markers: List<Marker>.generate(
                                    state.pets.length, (int index) {
                                  return Marker(
                                    width: 150,
                                    height: 150,
                                    point: LatLng(
                                        state.pets.elementAt(index).latitude!,
                                        state.pets.elementAt(index).longitude!),
                                    builder: (ctx) => _buildBody(state.pets.elementAt(index).name),
                                  );
                                }).toList(),
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
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                  height: 48,
                                                  width: 180,
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
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: ListView.builder(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            itemCount: state
                                                                .pets.length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int indexPet) {
                                                              return Container(
                                                                child: InkWell(
                                                                  splashColor: Colors.white,
                                                                  onTap: () {
                                                                    if (index != indexPet) {
                                                                      index = indexPet;
                                                                    }
                                                                    setState(() {});
                                                                    debugPrint('Card tapped.');
                                                                  },
                                                                  child: Container(
                                                                    child: Column(
                                                                      children: <Widget>[
                                                                        Center(
                                                                            child: Container(
                                                                                margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
                                                                                height: 32,
                                                                                width: 32,
                                                                                child: index == indexPet
                                                                                    ? (Container(
                                                                                  height: 32,
                                                                                  width: 32,
                                                                                  child: Stack(
                                                                                    clipBehavior: Clip.none,
                                                                                    fit: StackFit.expand,
                                                                                    children: [
                                                                                      CircleAvatar(
                                                                                        backgroundImage:  NetworkImage(state.pets.elementAt(indexPet).image),
                                                                                      ),
                                                                                      Positioned(
                                                                                          bottom: 0,
                                                                                          right: -2,
                                                                                          width: 12,
                                                                                          height: 12,
                                                                                          child: Container(
                                                                                            decoration: BoxDecoration(
                                                                                                color: Color.fromRGBO(97, 163, 153, 1),
                                                                                                borderRadius: BorderRadius.circular(20),
                                                                                                boxShadow: [
                                                                                                  BoxShadow(color: Colors.white, spreadRadius: 2),
                                                                                                ]
                                                                                            ),
                                                                                          )),
                                                                                    ],
                                                                                  ),
                                                                                ))
                                                                                    : (Container(
                                                                                  height: 32,
                                                                                  width: 32,
                                                                                  child: Stack(
                                                                                    clipBehavior: Clip.none,
                                                                                    fit: StackFit.expand,
                                                                                    children: [
                                                                                      CircleAvatar(
                                                                                        backgroundImage:  NetworkImage(state.pets.elementAt(indexPet).image),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                                ))
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }),
                                                      ),
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
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                        height: 48,
                                                        width: 48,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.9),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      148,
                                                                      161,
                                                                      187,
                                                                      0.2),
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
                                                                child:
                                                                    ClipRRect(
                                                                  child:
                                                                      Material(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            0),
                                                                    child:
                                                                        InkWell(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(0),
                                                                        child: SvgPicture
                                                                            .asset(
                                                                          "assets/images/maximize.svg",
                                                                          color: Color.fromRGBO(
                                                                              74,
                                                                              85,
                                                                              104,
                                                                              1),
                                                                        ),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        if (currentZoom <
                                                                            17)
                                                                          _mapController.move(
                                                                              _mapController.center,
                                                                              currentZoom += 1);
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
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.9),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      148,
                                                                      161,
                                                                      187,
                                                                      0.2),
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
                                                                child:
                                                                    ClipRRect(
                                                                  child:
                                                                      Material(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            0),
                                                                    child:
                                                                        InkWell(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(0),
                                                                        child: SvgPicture
                                                                            .asset(
                                                                          "assets/images/minimize.svg",
                                                                          color: Color.fromRGBO(
                                                                              74,
                                                                              85,
                                                                              104,
                                                                              1),
                                                                        ),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        if (currentZoom >
                                                                            2)
                                                                          _mapController.move(
                                                                              _mapController.center,
                                                                              currentZoom -= 1);
                                                                      },
                                                                    ),
                                                                  ),
                                                                )),
                                                          ],
                                                        )),
                                                  ],
                                                ),
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
                                                                    "assets/images/locate-current.svg",
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  setState(() {
                                                                    _mapController.move(LatLng(state.pets.elementAt(index).latitude!,
                                                                        state.pets.elementAt(index).longitude!), _mapController.zoom);
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          )),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ),
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
  String _currentAddress = "Not Found";

  PetCard({required this.pet, required this.fence});

  @override
  _PetCardState createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {

  Future<void> _getAddressFromLatLng() async {
    await placemarkFromCoordinates(widget.pet.latitude!, widget.pet.longitude!,
            localeIdentifier: "EN")
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        widget._currentAddress = '${place.street}, ${place.country}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    //_currentAddress = "Not Found";
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
                            SvgPicture.asset(widget.pet.imageBattery()),
                            SizedBox(
                              height: 3,
                            ),
                            Text("${widget.pet.charging}%"),
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
                            SvgPicture.asset(widget.pet.imageConnection()),
                            SizedBox(
                              height: 3,
                            ),
                            Text("${widget.pet.connection}%"),
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
                                widget._currentAddress +
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
