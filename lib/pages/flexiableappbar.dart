import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pawwismart/bloc/petBloc/pet_bloc.dart';
import 'package:pawwismart/pages/virtualFences.dart';

import '../bloc/bloc/auth_bloc.dart';
import '../data/repositories/pet_repository.dart';
import 'mapManyPets.dart';

class FlexiableAppBar extends StatelessWidget {
  final double appBarHeight = 30.0;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return BlocProvider(
        create: (context) => PetBloc(
      petRepository: PetRepository(),
    )..add(LoadPet()),
    child:    BlocBuilder<PetBloc, PetState>(
        builder: (context, state)
    {
      if (state is PetLoaded) {
        return Container(
          padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
          color: Color.fromRGBO(253, 253, 253, 1),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: Text('Hello, ',
                              style: TextStyle(
                                color: Color.fromRGBO(74, 85, 104, 1),
                                fontSize: 30,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w900,
                              )),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                              '${user.displayName?.split(' ')[0][0]
                                  .toUpperCase()}${user.displayName?.split(
                                  ' ')[0].substring(1).toLowerCase()}',
                              style: TextStyle(
                                color: Color.fromRGBO(151, 196, 232, 1),
                                fontSize: 30,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w900,
                              )),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: PopupMenuButton(
                                onSelected: (value) async {
                                  switch (value) {
                                    case 1:
                                      context
                                          .read<AuthBloc>()
                                          .add(SignOutRequested());
                                      break;
                                    default:
                                      throw UnimplementedError();
                                  }
                                },
                                elevation: 0.5,
                                child: SvgPicture.asset(
                                  "assets/images/menu.svg",
                                ),
                                itemBuilder: (BuildContext context) =>
                                [
                                  PopupMenuItem(
                                    child: Text("Log Out"),
                                    value: 1,
                                    onTap: () {},
                                  ),
                                ])),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 174,
                      height: 68,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(15, 10, 0, 15),
                      padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(148, 161, 187, 0.2),
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: InkWell(
                        splashColor: Colors.white,
                        onTap: () {
                          if(state.pets.length >=1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapManyPage(),
                              ),
                            );
                            debugPrint('{state.pets.length}');
                          }
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/images/mapHome.svg"),
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                  width: 110,
                                  height: 24,
                                  alignment: Alignment.centerLeft,
                                  child: Text('Locations',
                                      style: TextStyle(
                                        color: Color.fromRGBO(74, 85, 104, 1),
                                        fontSize: 24,
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.w900,
                                      )),
                                ),
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                    width: 110,
                                    height: 56,
                                    alignment: Alignment.centerLeft,
                                    child: Text('View locations\nof my pets',
                                        style: TextStyle(
                                          color: Color.fromRGBO(74, 85, 104, 1),
                                          fontSize: 12,
                                          fontFamily: 'Open Sans',
                                          fontWeight: FontWeight.w300,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 174,
                      height: 68,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(15, 10, 0, 15),
                      padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(148, 161, 187, 0.2),
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: InkWell(
                        splashColor: Colors.white,
                        onTap: () {
                          if(state.pets.length >=1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VirtualFencesPage(countPets: state.pets.length,),
                              ),
                            );
                            debugPrint('Card tapped.');
                          }
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/images/calendarHome.svg"),
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                  width: 110,
                                  height: 24,
                                  alignment: Alignment.centerLeft,
                                  child: Text('Fences',
                                      style: TextStyle(
                                        color: Color.fromRGBO(74, 85, 104, 1),
                                        fontSize: 24,
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.w900,
                                      )),
                                ),
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                    width: 110,
                                    height: 56,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        'View app virtial fences archive',
                                        style: TextStyle(
                                          color: Color.fromRGBO(74, 85, 104, 1),
                                          fontSize: 12,
                                          fontFamily: 'Open Sans',
                                          fontWeight: FontWeight.w300,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      return Container(
        padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
        color: Color.fromRGBO(253, 253, 253, 1),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Text('Hello, ',
                            style: TextStyle(
                              color: Color.fromRGBO(74, 85, 104, 1),
                              fontSize: 30,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w900,
                            )),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                            '${user.displayName?.split(' ')[0][0]
                                .toUpperCase()}${user.displayName?.split(
                                ' ')[0].substring(1).toLowerCase()}',
                            style: TextStyle(
                              color: Color.fromRGBO(151, 196, 232, 1),
                              fontSize: 30,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w900,
                            )),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: PopupMenuButton(
                              onSelected: (value) async {
                                switch (value) {
                                  case 1:
                                    context
                                        .read<AuthBloc>()
                                        .add(SignOutRequested());
                                    break;
                                  default:
                                    throw UnimplementedError();
                                }
                              },
                              elevation: 0.5,
                              child: SvgPicture.asset(
                                "assets/images/menu.svg",
                              ),
                              itemBuilder: (BuildContext context) =>
                              [
                                PopupMenuItem(
                                  child: Text("Log Out"),
                                  value: 1,
                                  onTap: () {},
                                ),
                              ])),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    width: 174,
                    height: 68,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(15, 10, 0, 15),
                    padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(148, 161, 187, 0.2),
                          spreadRadius: 0,
                          blurRadius: 2,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: InkWell(
                      splashColor: Colors.white,
                      onTap: () {
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/images/mapHome.svg"),
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                width: 110,
                                height: 24,
                                alignment: Alignment.centerLeft,
                                child: Text('Locations',
                                    style: TextStyle(
                                      color: Color.fromRGBO(74, 85, 104, 1),
                                      fontSize: 24,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w900,
                                    )),
                              ),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                  width: 110,
                                  height: 56,
                                  alignment: Alignment.centerLeft,
                                  child: Text('View locations\nof my pets',
                                      style: TextStyle(
                                        color: Color.fromRGBO(74, 85, 104, 1),
                                        fontSize: 12,
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.w300,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 174,
                    height: 68,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(15, 10, 0, 15),
                    padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(148, 161, 187, 0.2),
                          spreadRadius: 0,
                          blurRadius: 2,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: InkWell(
                      splashColor: Colors.white,
                      onTap: () {
                        debugPrint('Card tapped.');
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/images/calendarHome.svg"),
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                width: 110,
                                height: 24,
                                alignment: Alignment.centerLeft,
                                child: Text('Fences',
                                    style: TextStyle(
                                      color: Color.fromRGBO(74, 85, 104, 1),
                                      fontSize: 24,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w900,
                                    )),
                              ),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                  width: 110,
                                  height: 56,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      'View app virtial fences archive',
                                      style: TextStyle(
                                        color: Color.fromRGBO(74, 85, 104, 1),
                                        fontSize: 12,
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.w300,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    ),
    );
  }
}
