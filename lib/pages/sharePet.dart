import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../bloc/petBloc/pet_bloc.dart';
import '../bloc/share/share_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../data/model/pet.dart';
import '../data/model/share.dart';
import '../data/repositories/pet_repository.dart';
import '../data/repositories/share_repository.dart';
import '../data/repositories/user_repository.dart';
import 'inputValidationMixin.dart';

List<String> closedEmail = [];

class SharePetPage extends StatelessWidget with InputValidationMixin {
  Pet pet;
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  SharePetPage({required this.pet});

  @override
  Widget build(BuildContext context) {
    closedEmail.clear();
    return RepositoryProvider(
      create: (context) => UserRepository(),
      child: BlocProvider(
        create: (context) =>
            UserBloc(
              userRepository: UserRepository(),
            ),
        child: RepositoryProvider(
          create: (context) => ShareRepository(),
          child: BlocProvider(
            create: (context) =>
            ShareBloc(
              shareRepository: ShareRepository(),
            )
              ..add(LoadShare(pet.id!)),
            child: Builder(builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  // <-- app bar for logo
                  toolbarHeight: 0,
                  elevation: 0.0,
                  backgroundColor: Color.fromRGBO(74, 85, 104, 1),
                ),
                body: BlocBuilder<ShareBloc, ShareState>(
                    builder: (context, state) {
                      if (state is ShareLoaded) {
                        for (var user in state.share) {
                          closedEmail.add(user.email);
                        }
                        return Container(
                          child: Column(
                            children: [
                              PetCard(
                                pet: pet,
                              ),
                              Expanded(child:
                              ListView.builder(
                                itemCount: state.share.length,
                                itemBuilder: (context, index) {
                                  return ShareCard(
                                    share: state.share.elementAt(index),
                                  );
                                },
                              ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Container();
                    }),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    _shareEmailUser(context);
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
              );
            }),
          ),
        ),
      ),
    );
  }

  void _shareEmailUser(context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return BlocProvider(
            create: (context) =>
                UserBloc(
                  userRepository: UserRepository(),
                ),
            child: BlocProvider(
              create: (context) =>
                  ShareBloc(
                    shareRepository: ShareRepository(),
                  ), child: BlocProvider(
              create: (context) =>
                  PetBloc(
                    petRepository: PetRepository(),
                  ),
              child: BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserNoLoading) {
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
                              "Enter Email",
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
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 1.5,
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: _emailController,
                                  obscureText: false,
                                  validator: (email) {
                                    if (isEmailValid(email!))
                                      return null;
                                    else
                                      return 'Enter correct email';
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 10.0),
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Open Sans',
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w400),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Color.fromRGBO(74, 85, 104, 0.3),),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Color.fromRGBO(151, 196, 232, 1),),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Color.fromRGBO(
                                              255, 77, 120, 1)),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Color.fromRGBO(
                                              255, 77, 120, 1)),
                                    ),
                                    errorStyle: const TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Open Sans',
                                        color: Color.fromRGBO(255, 77, 120, 1),
                                        fontWeight: FontWeight.w300),
                                    floatingLabelBehavior: FloatingLabelBehavior
                                        .auto,
                                  ),
                                ),
                              ),
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
                                  if (_formKey.currentState!.validate()) {
                                    if (!closedEmail
                                        .contains(_emailController.text)) {
                                      BlocProvider.of<UserBloc>(context)
                                          .add(LoadUser(_emailController.text));
                                    }
                                  }
                                },
                                child: Center(
                                  child: Text(
                                    "Continue",
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
                    if (state is UserLoaded) {
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
                              "Share ${pet.name}",
                              style: TextStyle(
                                color: Color.fromRGBO(74, 85, 104, 1),
                                fontSize: 23,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 20.0),
                              child: Text("The user is ${state.user
                                  .email} found. Are you sure you want to share ${pet
                                  .name}'s pet location with ${state.user
                                  .name}?"),
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
                                  Share share = Share(IDUser: state.user.id,
                                      IDPet: pet.id!,
                                      name: state.user.name,
                                      email: state.user.email,
                                      date: DateTime.now(),
                                      isActive: true);
                                  BlocProvider.of<ShareBloc>(context).add(
                                      AddShare(share));
                                  BlocProvider.of<PetBloc>(context).add(
                                      SharePet(pet, state.user.id));
                                  Navigator.of(context).pop();
                                },
                                child: Center(
                                  child: Text(
                                    "Share ${state.user.name}",
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
                  }),
            ),
            ),
          );
        });
  }
}

class PetCard extends StatelessWidget {
  Pet pet;

  PetCard({required this.pet});

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
                    child: Text("Share ${pet.name}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w900,
                        )),
                  ),
                  Container(
                    child: Text(
                        "Share your pet's contact info with your friends and family",
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

class ShareCard extends StatelessWidget {
  Share share;

  ShareCard({required this.share});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
      color: Colors.white,
      elevation: 5.0,
      shadowColor: Color.fromRGBO(148, 161, 187, 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
        Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(150, 166, 228, 1),
                      borderRadius: BorderRadius.circular(10),
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
                        Text(share.date!.day.toString(), style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w900,
                        ),),
                        Text('${DateFormat("MMM").format(share.date!)} ${DateFormat("yyy").format(share.date!)}', style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                        ),),
                      ],
                    ),
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(share.name,
                                style: TextStyle(
                                  color: Color.fromRGBO(74, 85, 104, 1),
                                  fontSize: 23,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w900,
                                )),
                          ),
                          Container(
                            child: Text(share.email,
                                style: TextStyle(
                                  color: Color.fromRGBO(74, 85, 104, 1),
                                  fontSize: 14,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        ],
                      )
                  ),
                ],
              )
            ),
            Container(
              height: 48,
              width: MediaQuery.of(context).size.width / 6,
              child: FlatButton(
                onPressed: () {
                  _deleteShareDialog(context);
                },
                padding: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
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
                      "CLOSE",
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
    ],
    ),
    ),
    );// <== The Card class constructor
  }

  void _deleteShareDialog(context){
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
              "Stop Sharing",
                style: TextStyle(
                color: Color.fromRGBO(74, 85, 104, 1),
            fontSize: 23,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w900,
          )
            ),
            SizedBox(height: 15),
              BlocProvider(
              create: (context) =>
              ShareBloc(
                shareRepository: ShareRepository(),
              ), child: Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 0.0, horizontal: 20.0),
                child: Text("Are you sure you want to stop sharing your pet's location with ${share.name}? You can't undo this action."),
              ),
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
                  BlocProvider.of<ShareBloc>(context).add(DeleteShare(share));
                  closedEmail.remove(share.email);
                  Navigator.of(context).pop();
                },
                child: Center(
                  child: Text(
                    "Stop Sharing",
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
}
