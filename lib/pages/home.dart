import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pawwismart/bloc/petBloc/pet_bloc.dart';
import 'package:pawwismart/pages/flexiableappbar.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:pawwismart/pages/createPet.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../bloc/device/device_bloc.dart';
import '../bloc/share/share_bloc.dart';
import '../data/model/pet.dart';
import '../data/repositories/device_repository.dart';
import '../data/repositories/pet_repository.dart';
import '../data/repositories/share_repository.dart';

class Home extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<Home> {
  var top = 0.0;

  late ScrollController _scrollController;

  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PetRepository(),
      child: BlocProvider(
        create: (context) => PetBloc(
          petRepository: PetRepository(),
        )..add(LoadPet()),
        child: RepositoryProvider(
          create: (context) => ShareRepository(),
          child: BlocProvider(
            create: (context) => ShareBloc(
              shareRepository: ShareRepository(),
            )..add(LoadShare()),
            child: RepositoryProvider(
              create: (context) => DeviceRepository(),
              child: BlocProvider(
                create: (context) => DeviceBloc(
                  deviceRepository: DeviceRepository(),
                ),
                child: Builder(
                  builder: (context) {
                    return Scaffold(
                      backgroundColor: Color.fromRGBO(253, 253, 253, 1),
                      body: CustomScrollView(
                        controller: _scrollController,
                        slivers: <Widget>[
                          SliverAppBar(
                            // <-- app bar for logo
                            toolbarHeight: 0,
                            floating: false,
                            pinned: true,
                            elevation: 0.0,
                            backgroundColor: Color.fromRGBO(74, 85, 104, 1),
                          ),
                          SliverAppBar(
                              // <-- app bar for logo
                              toolbarHeight:
                                  MediaQuery.of(context).size.height / 7.6,
                              floating: false,
                              pinned: false,
                              elevation: 0.0,
                              backgroundColor: isShrink
                                  ? Color.fromRGBO(74, 85, 104, 1)
                                  : Color.fromRGBO(253, 253, 253, 1),
                              flexibleSpace: FlexibleSpaceBar(
                                background: FlexiableAppBar(),
                              )),
                          SliverAppBar(
                            // <-- app bar for custom sticky menu
                            primary: true,
                            toolbarHeight:
                                MediaQuery.of(context).size.height / 50,
                            floating: false,
                            pinned: true,
                            elevation: 0.0,
                            //floating: false,
                            backgroundColor: isShrink
                                ? Color.fromRGBO(74, 85, 104, 1)
                                : Color.fromRGBO(253, 253, 253, 1),
                            flexibleSpace: Container(
                              padding: isShrink
                                  ? const EdgeInsets.fromLTRB(15, 0, 0, 12)
                                  : const EdgeInsets.fromLTRB(15, 0, 0, 8),
                              alignment: Alignment.bottomLeft,
                              decoration: BoxDecoration(
                                  color: isShrink
                                      ? Color.fromRGBO(74, 85, 104, 1)
                                      : Color.fromRGBO(253, 253, 253, 1)),
                              child: Row(
                                children: [
                                  Text('My Pets',
                                      style: TextStyle(
                                        color: isShrink
                                            ? Color.fromRGBO(253, 253, 253, 1)
                                            : Color.fromRGBO(74, 85, 104, 1),
                                        fontSize: isShrink ? 24 : 30,
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.w900,
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: Container(
                                        //width: 30,
                                        height: 25,
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: isShrink
                                              ? Color.fromRGBO(86, 98, 120, 1)
                                              : Color.fromRGBO(
                                                  243, 246, 251, 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            BlocBuilder<PetBloc, PetState>(
                                                builder: (context, state) {
                                              if (state is PetLoaded) {
                                                return Text(
                                                    '${state.pets.length}',
                                                    style: TextStyle(
                                                      color: isShrink
                                                          ? Color.fromRGBO(
                                                              243, 246, 251, 1)
                                                          : Color.fromRGBO(
                                                              148, 161, 187, 1),
                                                      fontSize: 14,
                                                      fontFamily: 'Open Sans',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ));
                                              }
                                              return Text('0',
                                                  style: TextStyle(
                                                    color: isShrink
                                                        ? Color.fromRGBO(
                                                            243, 246, 251, 1)
                                                        : Color.fromRGBO(
                                                            148, 161, 187, 1),
                                                    fontSize: 14,
                                                    fontFamily: 'Open Sans',
                                                    fontWeight: FontWeight.w400,
                                                  ));
                                            }),
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                          BlocBuilder<PetBloc, PetState>(
                              builder: (context, state) {
                            if (state is PetLoaded) {
                              return SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (buildContext, index) {
                                    return Slidable(
                                      // Specify a key if the Slidable is dismissible.
                                      key: const ValueKey(0),
                                      // The end action pane is the one at the right or the bottom side.
                                      endActionPane: ActionPane(
                                        motion: BehindMotion(),
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                15, 0, 0, 0),
                                            padding:
                                                EdgeInsets.fromLTRB(5, 0, 0, 0),
                                            height: 70,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  243, 246, 251, 0.5),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                bottomLeft:
                                                    Radius.circular(10.0),
                                              ),
                                            ),
                                            child: CustomSlidableAction(
                                              onPressed: (_) {
                                                if (state.pets.elementAt(index).IDUser == FirebaseAuth.instance.currentUser!.uid)
                                                  confirmDialog(context, state.pets.elementAt(index));
                                              },
                                              backgroundColor:
                                                  Colors.transparent,
                                              foregroundColor: Color.fromRGBO(
                                                  243, 246, 251, 1),
                                              child: Container(
                                                  height: 70,
                                                  width: 200,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/images/trash.svg",
                                                        color: state.pets.elementAt(index).IDUser == FirebaseAuth.instance.currentUser!.uid
                                                            ? Color.fromRGBO(255, 79, 81, 1)
                                                            : Color.fromRGBO(148, 161, 187, 0.2),
                                                        height: 25,
                                                      ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text("Delete",
                                                          style: TextStyle(
                                                            color: state.pets.elementAt(index).IDUser == FirebaseAuth.instance.currentUser!.uid
                                                                ? Color.fromRGBO(255, 79, 81, 1)
                                                                : Color.fromRGBO(148, 161, 187, 0.2),
                                                            fontSize: 15,
                                                            fontFamily:
                                                                'Open Sans',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )),
                                                    ],
                                                  )),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                0, 0, 15, 0),
                                            padding:
                                                EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            height: 70,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  243, 246, 251, 0.5),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10.0),
                                                bottomRight:
                                                    Radius.circular(10.0),
                                              ),
                                            ),
                                            child: CustomSlidableAction(
                                              onPressed: (context) {
                                                if (state.pets.elementAt(index).IDUser != FirebaseAuth.instance.currentUser!.uid)
                                                  _removeSharePet(context, state.pets.elementAt(index));
                                                },
                                              backgroundColor:
                                                  Colors.transparent,
                                              foregroundColor: Color.fromRGBO(
                                                  243, 246, 251, 1),
                                              child: Container(
                                                  height: 70,
                                                  width: 200,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset("assets/images/share.svg",
                                                        color: Color.fromRGBO(
                                                            148, 161, 187, 1),
                                                        height: 25,
                                                      ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text(state.pets.elementAt(index).IDUser == FirebaseAuth.instance.currentUser!.uid ? "Share" : "Remove",
                                                          style: TextStyle(
                                                            color: Color.fromRGBO(148, 161, 187, 1),
                                                            fontSize: 15,
                                                            fontFamily:
                                                                'Open Sans',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )),
                                                    ],
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // The child of the Slidable is what the user sees when the
                                      // component is not dragged.
                                      child: PetCard(
                                          pet: state.pets.elementAt(index)),
                                    );
                                  },
                                  childCount: state.pets.length,
                                ),
                              );
                            }
                            if (state is PetLoading) {
                              return SliverList(
                                delegate: SliverChildListDelegate(
                                  [
                                    Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ],
                                ),
                              );
                            }
                            if (state is PetCreating) {
                              return SliverList(
                                delegate: SliverChildListDelegate(
                                  [
                                    Center(
                                      child: ScanScreen(),
                                    )
                                  ],
                                ),
                              );
                            }
                            return SliverList(
                              delegate: SliverChildListDelegate(
                                [
                                  Container(child: Text('No data')),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          _pressCreatePet(context);
                        },
                        elevation: 0,
                        backgroundColor: Color.fromRGBO(151, 196, 232, 1),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100.0))),
                        child: SvgPicture.asset("assets/images/petAdd.svg"),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _pressCreatePet(context) {
    BlocProvider.of<PetBloc>(context).add(
      CreatingPet(),
    );
  }
}

class PetCard extends StatelessWidget {
  late Pet pet;

  PetCard({required Pet pet}) {
    this.pet = pet;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
      color: Colors.white,
      elevation: 5.0,
      shadowColor: Color.fromRGBO(148, 161, 187, 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Center(
                    child: CircleAvatar(
                      radius: 45.0,
                      backgroundImage: NetworkImage(pet.image.toString()),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.57,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(pet.name,
                              style: TextStyle(
                                color: Color.fromRGBO(74, 85, 104, 1),
                                fontSize: 23,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w900,
                              )),
                        ),
                        Container(
                            child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Material(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: SvgPicture.asset(
                                    "assets/images/filterBig.svg"),
                              ),
                              onTap: () {
                                //_deletePet(context, pet);
                                _removeSharePet(context, pet);
                              },
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 0),
                    child: Text("111 57 Stockholm 4 mins ago",
                        style: TextStyle(
                          color: Color.fromRGBO(79, 79, 79, 1),
                          fontSize: 14,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                  Container(
                    height: 10,
                  ),
                  Container(
                    height: 35,
                    alignment: Alignment.centerLeft,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(243, 246, 251, 1),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text("Device ID${pet.IDDevice}",
                                  style: TextStyle(
                                    color: Color.fromRGBO(148, 161, 187, 1),
                                    fontSize: 14,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.07,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 6),
                              child:
                                  SvgPicture.asset("assets/images/NSLight.svg"),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                              child: SvgPicture.asset(
                                  "assets/images/batteryLight.svg"),
                            ),
                            Container(
                              child: Text("50%",
                                  style: TextStyle(
                                    color: Color.fromRGBO(148, 161, 187, 1),
                                    fontSize: 14,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
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

Future confirmDialog(context, Pet pet) async {
  return showDialog(
    context: context,
    barrierDismissible: true, // user must tap button for close dialog!
    builder: (_) {
      return AlertDialog(
        title: Text('Delete ${pet.name}?',
            style: TextStyle(
              color: Color.fromRGBO(74, 85, 104, 1),
              fontSize: 23,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w900,
            )),
        content: Text(
            'Are you sure you want to delete the pet? This action cannot be undone!',
            style: TextStyle(
              color: Color.fromRGBO(79, 79, 79, 1),
              fontSize: 16,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
            )),
        actions: <Widget>[
          FlatButton(
            minWidth: 50,
            child: Text('CANCEL',
                style: TextStyle(
                  color: Color.fromRGBO(79, 79, 79, 1),
                  fontSize: 18,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                )),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('DELETE',
                style: TextStyle(
                  color: Color.fromRGBO(255, 79, 81, 1),
                  fontSize: 18,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w900,
                )),
            onPressed: () {
              _deletePet(context, pet);
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}

void _deletePet(context, Pet pet) {
  BlocProvider.of<DeviceBloc>(context).add(UpdateIDDevice(pet.IDDevice, false));
  BlocProvider.of<PetBloc>(context).add(DeletePet(pet));
}

void _sharePet(context, Pet pet) {
  BlocProvider.of<PetBloc>(context)
      .add(SharePet(pet, "d052HRnhI9f5W7WAr1HwF759Nws1"));
}

void doNothing(BuildContext context) {}

void _removeSharePet(context, Pet pet) {
  BlocProvider.of<PetBloc>(context).add(RemoveSharePet(pet, FirebaseAuth.instance.currentUser!.uid));
}
