import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pawwismart/bloc/petBloc/pet_bloc.dart';
import 'package:pawwismart/pages/createPet.dart';
import 'package:pawwismart/pages/flexiableappbar.dart';
import 'package:pawwismart/pages/petImage.dart';
import 'package:pawwismart/pages/sharePet.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../bloc/device/device_bloc.dart';
import '../bloc/fence/fence_bloc.dart';
import '../bloc/share/share_bloc.dart';
import '../data/model/pet.dart';
import '../data/repositories/device_repository.dart';
import '../data/repositories/fence_repository.dart';
import '../data/repositories/pet_repository.dart';
import '../data/repositories/share_repository.dart';
import 'Scanner.dart';
import 'inputValidationMixin.dart';
import 'mapOnePet.dart';

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
          create: (context) => DeviceRepository(),
          child: BlocProvider(
            create: (context) => DeviceBloc(
              deviceRepository: DeviceRepository(),
            ),
            child: RepositoryProvider(
              create: (context) => FenceRepository(),
              child: BlocProvider(
                create: (context) => FenceBloc(
                  fenceRepository: FenceRepository(),
                ),
                child: RepositoryProvider(
                  create: (context) => ShareRepository(),
                  child: BlocProvider(
                    create: (context) => ShareBloc(
                      shareRepository: ShareRepository(),
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
                                                ? Color.fromRGBO(
                                                    253, 253, 253, 1)
                                                : Color.fromRGBO(
                                                    74, 85, 104, 1),
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
                                                                243,
                                                                246,
                                                                251,
                                                                1)
                                                            : Color.fromRGBO(
                                                                148,
                                                                161,
                                                                187,
                                                                1),
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
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ));
                                              }),
                                            ],
                                          ),
                                        ),
                                      ),
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
                                                padding: EdgeInsets.fromLTRB(
                                                    5, 0, 0, 0),
                                                height: 70,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      243, 246, 251, 0.5),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10.0),
                                                    bottomLeft:
                                                        Radius.circular(10.0),
                                                  ),
                                                ),
                                                child: CustomSlidableAction(
                                                  onPressed: (_) {
                                                    if (state.pets
                                                            .elementAt(index)
                                                            .IDUser ==
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid)
                                                      confirmDialog(
                                                          context,
                                                          state.pets.elementAt(
                                                              index));
                                                  },
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  foregroundColor:
                                                      Color.fromRGBO(
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
                                                            color: state.pets
                                                                        .elementAt(
                                                                            index)
                                                                        .IDUser ==
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid
                                                                ? Color
                                                                    .fromRGBO(
                                                                        255,
                                                                        79,
                                                                        81,
                                                                        1)
                                                                : Color
                                                                    .fromRGBO(
                                                                        148,
                                                                        161,
                                                                        187,
                                                                        0.2),
                                                            height: 25,
                                                          ),
                                                          SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text("Delete",
                                                              style: TextStyle(
                                                                color: state.pets
                                                                            .elementAt(
                                                                                index)
                                                                            .IDUser ==
                                                                        FirebaseAuth
                                                                            .instance
                                                                            .currentUser!
                                                                            .uid
                                                                    ? Color
                                                                        .fromRGBO(
                                                                            255,
                                                                            79,
                                                                            81,
                                                                            1)
                                                                    : Color
                                                                        .fromRGBO(
                                                                            148,
                                                                            161,
                                                                            187,
                                                                            0.2),
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    'Open Sans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              )),
                                                        ],
                                                      )),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 15, 0),
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),
                                                height: 70,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      243, 246, 251, 0.5),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10.0),
                                                    bottomRight:
                                                        Radius.circular(10.0),
                                                  ),
                                                ),
                                                child: CustomSlidableAction(
                                                  onPressed: (context) {
                                                    if (state.pets
                                                            .elementAt(index)
                                                            .IDUser !=
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid) {
                                                      _removeSharePet(
                                                          context,
                                                          state.pets.elementAt(
                                                              index));
                                                    }
                                                    if (state.pets
                                                            .elementAt(index)
                                                            .IDUser ==
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid) {
                                                      _sharePet(
                                                          context,
                                                          state.pets.elementAt(
                                                              index));
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                SharePetPage(
                                                                    pet: state
                                                                        .pets
                                                                        .elementAt(
                                                                            index))),
                                                      );
                                                    }
                                                  },
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  foregroundColor:
                                                      Color.fromRGBO(
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
                                                            "assets/images/share.svg",
                                                            color:
                                                                Color.fromRGBO(
                                                                    148,
                                                                    161,
                                                                    187,
                                                                    1),
                                                            height: 25,
                                                          ),
                                                          SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text(
                                                              state.pets
                                                                          .elementAt(
                                                                              index)
                                                                          .IDUser ==
                                                                      FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid
                                                                  ? "Share"
                                                                  : "Close",
                                                              style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        148,
                                                                        161,
                                                                        187,
                                                                        1),
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    'Open Sans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
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
                                            pet: state.pets.elementAt(index),
                                            index: index,
                                          ),
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

class PetCard extends StatefulWidget {
  late Pet pet;
  late int index;

  PetCard({required Pet pet, required this.index}) {
    this.pet = pet;
  }

  @override
  _PetCardState createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> with InputValidationMixin {
  String _currentAddress = "Not Found";

  Future<void> _getAddressFromLatLng() async {
    await placemarkFromCoordinates(widget.pet.latitude!, widget.pet.longitude!,
            localeIdentifier: "EN")
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = '${place.street}, ${place.country}';
      });
    }).catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    _getAddressFromLatLng();
    return Card(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
      color: Colors.white,
      elevation: 5.0,
      shadowColor: Color.fromRGBO(148, 161, 187, 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        splashColor: Colors.white,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MapOnePage(),
              settings: RouteSettings(
                arguments: widget.index,
              ),
            ),
          );
          debugPrint('Card tapped.');
        },
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
                        backgroundImage:
                            NetworkImage(widget.pet.image.toString()),
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
                            child: Text(widget.pet.name,
                                style: TextStyle(
                                  color: Color.fromRGBO(74, 85, 104, 1),
                                  fontSize: 23,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w900,
                                )),
                          ),
                          widget.pet.IDUser !=
                                  FirebaseAuth.instance.currentUser!.uid
                              ? (Container())
                              : (PopupMenuButton(
                                  onSelected: (value) async {
                                    switch (value) {
                                      case 1:
                                        return editInfoPet(context, widget.pet);
                                      case 2:
                                        return editDevicePet(context, widget.pet);
                                        break;
                                      case 3:
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SharePetPage(
                                                      pet: widget.pet)),
                                        );
                                        break;
                                      case 4:
                                        return confirmDialog(
                                            context, widget.pet);
                                      default:
                                        throw UnimplementedError();
                                    }
                                  },
                                  elevation: 0.5,
                                  child: SvgPicture.asset(
                                    "assets/images/filterBig.svg",
                                  ),
                                  itemBuilder: (BuildContext context) => [
                                        PopupMenuItem(
                                          child: Text("Edit Info"),
                                          value: 1,
                                          onTap: () {},
                                        ),
                                        PopupMenuItem(
                                          child: Text("Device"),
                                          value: 2,
                                          onTap: () {},
                                        ),
                                        PopupMenuItem(
                                          child: Text("Share"),
                                          value: 3,
                                          onTap: () {},
                                        ),
                                        PopupMenuItem(
                                          child: Text("Delete"),
                                          value: 4,
                                          onTap: () {},
                                        ),
                                      ])),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.75,
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 0),
                      child: Text(
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
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      height: 35,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 10),
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
                                child: Text("Device ID${widget.pet.IDDevice}",
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
                                child: SvgPicture.asset(
                                    "assets/images/NSLight.svg"),
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
      ),
    ); // <== The Card class constructor
  }

  Future editInfoPet(context, Pet pet) async {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    String Image = pet.image;

    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button for close dialog!
      builder: (_) {
        _nameController.text = pet.name;
        return StatefulBuilder(builder: (_, setState) {
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
                Text('Edit ${pet.name}',
                    style: TextStyle(
                      color: Color.fromRGBO(74, 85, 104, 1),
                      fontSize: 23,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w900,
                    )),
                SizedBox(height: 15),
                Form(
                  key: _formKey,
                  child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                      child: Column(
                        children: [
                          Center(
                            child: PetImage(
                              imagePet: Image,
                              onFileChanged: (imageUrl) {
                                setState(() {
                                  Image = imageUrl;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
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
                                      color:
                                          Color.fromRGBO(114, 117, 168, 0.5)),
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
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                              ),
                            ),
                          ),
                        ],
                      )),
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
                          _editPet(
                              context, pet.id!, _nameController.text, Image);
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
      },
    );
  }
}

Future confirmDialog(context, Pet pet) async {
  return showDialog(
    context: context,
    barrierDismissible: true, // user must tap button for close dialog!
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
            Text('Delete ${pet.name}?',
                style: TextStyle(
                  color: Color.fromRGBO(74, 85, 104, 1),
                  fontSize: 23,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w900,
                )),
            SizedBox(height: 15),
            Container(
              margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              child: Text(
                  'Are you sure you want to delete the pet? This action cannot be undone!',
                  style: TextStyle(
                    color: Color.fromRGBO(79, 79, 79, 1),
                    fontSize: 16,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w400,
                  )),
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
                  _deletePet(context, pet);
                  Navigator.of(context).pop();
                },
                child: Center(
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Theme.of(context).primaryColor,
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
    },
  );
}

void editDevicePet(context, Pet pet) async {
  return showDialog(
    context: context,
    barrierDismissible: true, // user must tap button for close dialog!
    builder: (BuildContext ctx) {
      return RepositoryProvider(
        create: (context) => DeviceRepository(),
        child: BlocProvider(
          create: (context) => DeviceBloc(
            deviceRepository: DeviceRepository(),
          ),
          child:RepositoryProvider(
              create: (context) => PetRepository(),
              child: BlocProvider(
              create: (context) => PetBloc(
            petRepository: PetRepository(),
      ),
      child: Builder(
      builder: (context) {
        return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
          if (state is DeviceLoading) {
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
                  Text('Edit device ${pet.name}',
                      style: TextStyle(
                        color: Color.fromRGBO(74, 85, 104, 1),
                        fontSize: 23,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w900,
                      )),
                  SizedBox(height: 15),
                  Container(
                    margin:
                    EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                    child: Text(
                        'Are you sure you want to delete the pet? This action cannot be undone!',
                        style: TextStyle(
                          color: Color.fromRGBO(79, 79, 79, 1),
                          fontSize: 16,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                  SizedBox(height: 20),
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
                        _scanQR(ctx, context);
                        //Navigator.of(context).pop();
                      },
                      child: Center(
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Theme
                                .of(context)
                                .primaryColor,
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
          }
          if (state is DeviceLoaded) {
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
                  Text('Edit Found',
                      style: TextStyle(
                        color: Color.fromRGBO(74, 85, 104, 1),
                        fontSize: 23,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w900,
                      )),
                  SizedBox(height: 15),
                  Container(
                    margin:
                    EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                    child: Text(
                        'Are you sure you want to delete the pet? This action cannot be undone!',
                        style: TextStyle(
                          color: Color.fromRGBO(79, 79, 79, 1),
                          fontSize: 16,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                  SizedBox(height: 20),
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
                        BlocProvider.of<DeviceBloc>(context).add(
                            UpdateIDDevice(pet.IDDevice, false));
                        BlocProvider.of<DeviceBloc>(context).add(
                            UpdateIDDevice(state.device.IDDevice, true));
                        BlocProvider.of<PetBloc>(context).add(
                            EditPetDevice(pet.id!, state.device.IDDevice));
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Theme
                                .of(context)
                                .primaryColor,
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
          }
          return Container();
        });
      }),
      ),
      ),
      ),
      );
    },
  );
}

Future _scanQR(ctx, context) async {
  String _result;
  final result = await Navigator.push(
      ctx, MaterialPageRoute(builder: (c) => Scanner()));
  _result = result;
  _editPetDevice(context, _result);
}

void _editPetDevice(context, String code) {
  BlocProvider.of<DeviceBloc>(context).add(
    LoadDevice(code),
  );
}

void _deletePet(context, Pet pet) {
  BlocProvider.of<FenceBloc>(context).add(DeleteFenceWithDeletePet(pet.id!));
  BlocProvider.of<FenceBloc>(context).add(DeleteFenceNull());
  BlocProvider.of<PetBloc>(context)
      .add(RemoveSharePet(pet, FirebaseAuth.instance.currentUser!.uid));
  BlocProvider.of<ShareBloc>(context).add(
      DeleteShareFriend(pet.id!, FirebaseAuth.instance.currentUser!.email!));
  BlocProvider.of<DeviceBloc>(context).add(UpdateIDDevice(pet.IDDevice, false));
  BlocProvider.of<PetBloc>(context).add(DeletePet(pet));
}

void _sharePet(context, Pet pet) {
  BlocProvider.of<ShareBloc>(context).add(LoadShare(pet.id!));
}

void doNothing(BuildContext context) {}

void _removeSharePet(context, Pet pet) {
  BlocProvider.of<PetBloc>(context)
      .add(RemoveSharePet(pet, FirebaseAuth.instance.currentUser!.uid));
  BlocProvider.of<ShareBloc>(context).add(
      DeleteShareFriend(pet.id!, FirebaseAuth.instance.currentUser!.email!));
}

void _editPet(context, String id, String name, String image) {
  BlocProvider.of<PetBloc>(context).add(EditPet(id, name, image));
}
