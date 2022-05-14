import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:pawwismart/bloc/petBloc/pet_bloc.dart';
import 'package:pawwismart/data/repositories/pet_repository.dart';

import '../data/model/pet.dart';

class MapOnePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapOnePage();
  }
}

class _MapOnePage extends State<MapOnePage> {
  late MapController _mapController;
  var index;

  @override
  void initState() {
    _mapController = MapController();
    super.initState();
  }

  Widget build(BuildContext context) {
    index = ModalRoute.of(context)!.settings.arguments as int;
    return RepositoryProvider(
      create: (context) => PetRepository(),
      child: BlocProvider(
        create: (context) => PetBloc(
          petRepository: PetRepository(),
        )..add(LoadPet()),
        child: BlocBuilder<PetBloc, PetState>(builder: (context, state) {
          if (state is PetLoaded) {
            return Scaffold(
              body: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      controller: _mapController,
                      center: LatLng(state.pets.elementAt(index).latitude!,
                          state.pets.elementAt(index).longitude!),
                      interactiveFlags:
                          InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                      zoom: 14,
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
                      MarkerLayerOptions(
                        markers: [
                          Marker(
                            width: 60.0,
                            height: 60.0,
                            point: LatLng(state.pets.elementAt(index).latitude!,
                                state.pets.elementAt(index).longitude!),
                            builder: (ctx) => Container(
                                child: Column(
                              children: [
                                Container(
                                  child:
                                      SvgPicture.asset("assets/images/map.svg"),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text("${state.pets.elementAt(index).name}",
                                    style: TextStyle(
                                      color: Color.fromRGBO(74, 85, 104, 1),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    height: 48,
                                    width: 48,
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
                                                      "assets/images/close.svg",
                                                      color: Color.fromRGBO(
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
                                  child: Row(
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
                                                          child:
                                                              SvgPicture.asset(
                                                            "assets/images/maximize.svg",
                                                            color:
                                                                Color.fromRGBO(
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
                                                          child:
                                                              SvgPicture.asset(
                                                            "assets/images/minimize.svg",
                                                            color:
                                                                Color.fromRGBO(
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
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
                                                    child:
                                                    SvgPicture.asset(
                                                      "assets/images/save_zone.svg",
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
                                                    child:
                                                    SvgPicture.asset(
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
                                PetCart(pet: state.pets.elementAt(index),),
                            ],),
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
}

class PetCart extends StatelessWidget {

  Pet pet;

  PetCart({required this.pet});

  @override
  Widget build(BuildContext context) {
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
                          backgroundImage: NetworkImage(pet.image.toString()),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pet.name,
                                style: TextStyle(
                                  color: Color.fromRGBO(74, 85, 104, 1),
                                  fontSize: 19,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w900,
                                )),
                            Text("Brooklin 56 mins ago",
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
                  Text("Virtual Fence 5",
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
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 3, 10, 0),
                          decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            "Home",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 3, 10, 0),
                          decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            "Park",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 3, 10, 0),
                          decoration: BoxDecoration(
                              color: Colors.deepPurpleAccent,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            "Garden",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 3, 10, 0),
                          decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            "Home",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 3, 10, 0),
                          decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            "Home",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                      ],
                    ),
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
