import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pawwismart/pages/mapFence.dart';
import 'package:pawwismart/pages/toastWidget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../bloc/fence/fence_bloc.dart';
import '../bloc/petBloc/pet_bloc.dart';
import '../data/model/fence.dart';
import '../data/model/pet.dart';
import '../data/repositories/fence_repository.dart';
import '../data/repositories/pet_repository.dart';

class VirtualFencesPage extends StatelessWidget {
  int fenceCount = 0;
  int countPets;

  VirtualFencesPage({required this.countPets});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => FenceRepository(),
      child: BlocProvider(
        create: (context) =>
        FenceBloc(
          fenceRepository: FenceRepository(),
        )..add(LoadFences(FirebaseAuth.instance.currentUser!.uid)),
        child: Scaffold(
          appBar: AppBar(
            // <-- app bar for logo
            toolbarHeight: 0,
            elevation: 0.0,
            backgroundColor: Color.fromRGBO(74, 85, 104, 1),
          ),
          body: Container(
            child: Column(
              children: [
                FencesCard(),
                BlocBuilder<FenceBloc, FenceState>(builder: (context, state) {
                  if (state is FenceLoaded) {
                    fenceCount = state.fence.length;
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: GridView.builder(
                            gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 250,
                                childAspectRatio: 1.35,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                            itemCount: state.fence.length,
                            itemBuilder: (BuildContext ctx, index) {
                              return FenceCard(
                                fence: state.fence.elementAt(index),
                                countPet: countPets,
                              );
                            }),
                      ),
                    );
                  }
                  return Container();
                }),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Position pos = await _getGeoLocationPosition();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapPage(lat: pos.latitude, lng: pos.longitude, zoom: 14, lenghtFence: fenceCount, createNoPets: true,isEdit: false,),
                ),
              );
            },
            elevation: 0,
            backgroundColor: Color.fromRGBO(151, 196, 232, 1),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100.0))),
            child: SvgPicture.asset(
              "assets/images/plus.svg",
              height: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

Future<Position> _getGeoLocationPosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    await Geolocator.openLocationSettings();
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {

      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}

class FencesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(15, 20, 15, 15),
      color: Colors.white,
      elevation: 5.0,
      shadowColor: Color.fromRGBO(148, 161, 187, 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Material(
                    color: Color.fromRGBO(255, 255, 255, 0),
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: SvgPicture.asset("assets/images/close.svg"),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )),
            Container(
              height: 55,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text("Virtual Fences",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w900,
                        )),
                  ),
                  Container(
                    child: Text("Your virtual pet fences",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                  Container(
                    height: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ); // <== The Card class constructor
  }
}

class FenceCard extends StatelessWidget {
  Fence fence;
  int countPet;
  final settings = RestrictedAmountPositions(
    maxAmountItems: 5,
    maxCoverage: 0.5,
    minCoverage: 0.2,
  );

  FenceCard({required this.fence, required this.countPet});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PetRepository(),
      child: BlocProvider(
        create: (context) =>
            PetBloc(
              petRepository: PetRepository(),
            )..add(LoadPetsFence(fence.pets!)),
        child: Card(
          color: Colors.white,
          elevation: 5.0,
          shadowColor: Color.fromRGBO(148, 161, 187, 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            child: BlocBuilder<PetBloc, PetState>(builder: (context, state) {
              if (state is PetLoaded) {
                BlocProvider.of<PetBloc>(context).add(LoadPetsFence(fence.pets!));
                return Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: fence.color,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          )
                        ),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${fence.name}", style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w900,
                            )),
                          PopupMenuButton(
                            onSelected: (value) async{
                              switch (value) {
                                case 1: if(fence.pets!.length >= 1 && fence.pets!.length != countPet) return _choicePetsFence(context);
                                else showToast(context, "Incorrect data. You cannot add a pet.");
                                        break;
                                case 2: if(fence.pets!.length != 1) return _deletePetsFence(context);
                                else showToast(context, "Incorrect data. You cannot delete a pet.");
                                        break;
                                case 3: Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapPage(lat: fence.latitudeCenter, lng: fence.longitudeCenter, zoom: fence.zoom, lenghtFence: 1, createNoPets: false, isEdit: true, latLng: fence.getLatLng(), color: fence.color, nameFence: fence.name, pet: fence.pets!, fenceId: fence.id,),
                                    ),);
                                  break;
                                case 4: return _deleteFenceDialog(context);
                                default: throw UnimplementedError();
                              }
                            },
                              elevation: 0.5,
                              child: SvgPicture.asset("assets/images/more-vertical.svg", color: Color.fromRGBO(255, 255, 255, 1)),
                              itemBuilder: (BuildContext context)
                              =>
                              [
                                PopupMenuItem(
                                  child: Text("Add Pets", style: TextStyle(
                                    color: (fence.pets!.length >= 1 && fence.pets!.length != countPet) ? Colors.black : Color.fromRGBO(148, 161, 187, 0.5) ,
                                  ),),
                                  value: 1,
                                  onTap: (){},
                                ),
                                PopupMenuItem(
                                  child: Text("Delete Pets", style: TextStyle(
                                    color: fence.pets!.length != 1 ? Colors.black : Color.fromRGBO(148, 161, 187, 0.5),
                                  ),),
                                  value: 2,
                                  onTap: (){},
                                ),
                                PopupMenuItem(
                                  child: Text("Edit"),
                                  value: 3,
                                  onTap: (){},
                                ),
                                PopupMenuItem(
                                  child: Text("Delete", style: TextStyle(color: Color.fromRGBO(255, 77, 120, 1),),),
                                  value: 4,
                                  onTap: (){},
                                ),
                              ]
                          ),
                          ],
                        ),
                        ),
                      ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Pets using this fence", style: TextStyle(
                          color: Color.fromRGBO(148, 161, 187, 1),
                          fontSize: 13,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                        )),
                        SizedBox(height: 3,),
                        AvatarStack(
                          settings: settings,
                          height: 35,
                          avatars: [
                            for (var n = 0; n < state.pets.length; n++)
                              NetworkImage('${state.pets.elementAt(n).image}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ])
                );
              }
              return Container(
              );
            }
            ),
          ),
        ),
      ),
    );
  }

  void _deleteFenceDialog(context){
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
                Text(
                    "Delete Fence",
                    style: TextStyle(
                      color: Color.fromRGBO(74, 85, 104, 1),
                      fontSize: 23,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w900,
                    )
                ),
                SizedBox(height: 15),
              Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 20.0),
                  child: Text("Do you really want to delete this fence? This item will be deleted immediately. You can't undo this action.",),
                ),
                SizedBox(height: 15),
                Divider(
                  height: 1,
                ),
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: 50,
                  child: InkWell(
                    highlightColor: Colors.grey[200],
                    onTap: () {
                      BlocProvider.of<FenceBloc>(context).add(DeleteFence(fence));
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Color.fromRGBO(255, 77, 120, 1),
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
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
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
    List<Pet> NotPetsFence = [];
    bool flag = false;

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
                        "Select Pets (" + indexSelect.length.toString() +")",
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
                          if(!flag) {
                            for (var item in state.pets) {
                              if (!fence.pets!.contains(item.id)) {
                                NotPetsFence.add(item);
                              }
                            }
                            flag = true;
                          }
                          return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container( margin: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 20.0),
                                  child: Text("Select the pets your want to put into safe zone " + fence.name + ":", style: TextStyle(
                                    color: Color.fromRGBO(79, 79, 79, 1),
                                    fontSize: 14,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w400,
                                  )),),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 10.0),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    //cacheExtent: 3,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      // Количество элементов горизонтальной оси
                                        crossAxisCount: 4,
                                        // Расстояние по вертикальной оси
                                        mainAxisSpacing: 5.0,
                                        // Расстояние по горизонтальной оси
                                        crossAxisSpacing: 0.0,
                                        // Отношение ширины подкомпонента к высоте
                                        childAspectRatio: 1.0),
                                    scrollDirection: Axis.vertical,
                                    itemCount: NotPetsFence.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        child: InkWell(
                                          splashColor: Colors.white,
                                          onTap: () {
                                            if (!indexSelect.contains(index)) {
                                              indexSelect.add(index);
                                              petsSelect.add(NotPetsFence.
                                                  elementAt(index)
                                                  .id);
                                            } else {
                                              indexSelect.remove(index);
                                              petsSelect.remove(NotPetsFence.
                                                  elementAt(index)
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
                                                        child: indexSelect
                                                            .contains(index)
                                                            ? (SizedBox(
                                                          height: 50,
                                                          width: 50,
                                                          child: Stack(
                                                            clipBehavior: Clip.none,
                                                            fit: StackFit.expand,
                                                            children: [
                                                              CircleAvatar(
                                                                backgroundImage:  NetworkImage(NotPetsFence.elementAt(index).image),
                                                              ),
                                                              Positioned(
                                                                  bottom: 0,
                                                                  right: -5,
                                                                  width: 22,
                                                                  height: 22,
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                        color: Color.fromRGBO(97, 163, 153, 1),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                        boxShadow: [
                                                                          BoxShadow(color: Colors.white, spreadRadius: 2),
                                                                        ]
                                                                    ),
                                                                    child: SvgPicture.asset("assets/images/check.svg", color: Colors.white, height: 8,),
                                                                    alignment: Alignment.center,
                                                                  )),
                                                            ],
                                                          ),
                                                        ))
                                                            : (SizedBox(
                                                          height: 50,
                                                          width: 50,
                                                          child: Stack(
                                                            clipBehavior: Clip.none,
                                                            fit: StackFit.expand,
                                                            children: [
                                                              CircleAvatar(
                                                                backgroundImage:  NetworkImage(NotPetsFence.elementAt(index).image),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                        ))
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  NotPetsFence.
                                                      elementAt(index)
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
                          if(petsSelect.length >= 1) {
                            BlocProvider.of<FenceBloc>(context).add(
                                AddPetsFence(fence, petsSelect));
                            Navigator.of(context).pop();
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
  void _deletePetsFence(context) {
    List<dynamic> indexSelect = [];
    List<dynamic> petsSelect = [];
    int count = 0;
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
                )..add(LoadPetsFence(fence.pets!)),
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
                        "Delete Pets (" + indexSelect.length.toString() +")",
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
                          count = state.pets.length;
                          return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container( margin: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 20.0),
                                  child: Text("Select the pets your want to put into safe zone " + fence.name + ":", style: TextStyle(
                                    color: Color.fromRGBO(79, 79, 79, 1),
                                    fontSize: 14,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w400,
                                  )),),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 10.0),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    //cacheExtent: 3,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                                      child: indexSelect
                                                          .contains(index)
                                                          ? (SizedBox(
                                                        height: 50,
                                                        width: 50,
                                                        child: Stack(
                                                          clipBehavior: Clip.none,
                                                          fit: StackFit.expand,
                                                          children: [
                                                            CircleAvatar(
                                                              backgroundImage:  NetworkImage(state.pets.elementAt(index).image),
                                                            ),
                                                            Positioned(
                                                                bottom: 0,
                                                                right: -5,
                                                                width: 22,
                                                                height: 22,
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Color.fromRGBO(97, 163, 153, 1),
                                                                    borderRadius: BorderRadius.circular(20),
                                                                    boxShadow: [
                                                                      BoxShadow(color: Colors.white, spreadRadius: 2),
                                                                    ]
                                                                  ),
                                                                  child: SvgPicture.asset("assets/images/check.svg", color: Colors.white, height: 8,),
                                                                  alignment: Alignment.center,
                                                                )),
                                                          ],
                                                        ),
                                                      ))
                                                          : (SizedBox(
                                                        height: 50,
                                                        width: 50,
                                                        child: Stack(
                                                          clipBehavior: Clip.none,
                                                          fit: StackFit.expand,
                                                          children: [
                                                            CircleAvatar(
                                                              backgroundImage:  NetworkImage(state.pets.elementAt(index).image),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                      ))
                                                ),
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
            if(petsSelect.length >= 1 && petsSelect.length < count) {
              BlocProvider.of<FenceBloc>(context).add(
                  DeletePetsFence(fence, petsSelect));
              Navigator.of(context).pop();
            } else showToast(context, "Incorrect data. You cannot delete a pet.");
                          },
                          child: Center(
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Color.fromRGBO(255, 77, 120, 1),
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
