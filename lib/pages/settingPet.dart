import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/bloc/auth_bloc.dart';
import '../data/model/pet.dart';

class SettingPet extends StatelessWidget {
  Pet pet;

  SettingPet({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        // <-- app bar for logo
        toolbarHeight: 0,
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(74, 85, 104, 1),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          children: [
            PetCard(pet: pet,),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(15, 8, 0, 8),
              child: Text('General Settings',
                  style: TextStyle(
                    color: Color.fromRGBO(151, 196, 232, 1),
                    fontSize: 26,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w900,)
              ),
            ),
           // SettingCardSwitch("LOST PETS", "Let me know if there is a lost pet in the vicibity"),
            SettingCardButton("Edit Information", "Change your pet's name and photo", 1),
            SettingCardButton("Device", "Change your pet's device", 2),
            SettingCardButton("Share", "Share pet's contacts with your friends", 3),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(15, 8, 0, 8),
              child: Text('Remove',
                  style: TextStyle(
                    color: Color.fromRGBO(151, 196, 232, 1),
                    fontSize: 26,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w900,)
              ),
            ),
            SettingCardButton("Delete", "Delete my account and data in the app", 4),
          ],
        ),
      ),
    );
  }
}

class PetCard extends StatelessWidget {
  Pet pet;

  PetCard({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
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
            fit: BoxFit.cover,
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
                padding: const EdgeInsets.fromLTRB(0,0,0,0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Material(
                    color: Color.fromRGBO(255, 255, 255, 0),
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: SvgPicture.asset(
                            "assets/images/close.svg"),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )
            ),
            Container(
              height: 55,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(pet.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w900,
                        )),
                  ),
                  Container(
                    child: Text("Device ID" + pet.IDDevice,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                  Container(
                    height: 10,
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

class SettingCardButton extends StatelessWidget {

  late String parameter;
  late String description;
  late int index;

  SettingCardButton(this.parameter, this.description, this.index);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(0, 1, 1, 0),
      borderOnForeground: true,
      color: Colors.white,
      elevation: 0.0,
      shadowColor: Color.fromRGBO(148, 161, 187, 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Container(
        padding:  EdgeInsets.fromLTRB(10, 8, 15, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 3),
                  child: Text(parameter,
                      style: TextStyle(
                        color: Color.fromRGBO(74, 85, 104, 1),
                        fontSize: 18,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w700,
                      letterSpacing: 0.1)
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text(description,
                      style: TextStyle(
                        color: Color.fromRGBO(74, 85, 104, 1),
                        fontSize: 14,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w300,)
                  ),
                )
              ],
            ),
            Container(
              height: 32,
              width: 32,
              child: FlatButton(
                onPressed: () {},
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
                    child: SvgPicture.asset(
                        "assets/images/chevron-right.svg"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ); // <== The Card class constructor
  }
}
