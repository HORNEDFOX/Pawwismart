import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pawwismart/pages/settingApp.dart';
import 'package:pawwismart/pages/slideRightRoute.dart';
import 'package:page_transition/page_transition.dart';

import '../bloc/bloc/auth_bloc.dart';
import 'home.dart';

class FlexiableAppBar extends StatelessWidget {
  final double appBarHeight = 30.0;
  final user = FirebaseAuth.instance.currentUser!;

  FlexiableAppBar();

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

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
                      child: Text('${user.displayName}',
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
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Material(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: SvgPicture.asset(
                                    "assets/images/bellPinFill.svg"),
                              ),
                              onTap: () {
                                context
                                    .read<AuthBloc>()
                                    .add(SignOutRequested());
                              },
                            ),
                          ),
                        )),
                    Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Material(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child:
                                    SvgPicture.asset("assets/images/menu.svg"),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                      alignment: Alignment.bottomCenter,
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 800),
                                      reverseDuration:
                                          Duration(milliseconds: 400),
                                      type:
                                          PageTransitionType.rightToLeftJoined,
                                      child: SettingApp(),
                                      childCurrent: Home(),
                                    ));
                              },
                              //Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftJoined, child: const SettingApp()));
                              // },
                            ),
                          ),
                        )),
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
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
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
                              child: Text('View the location of my pets',
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
                Container(
                  width: 174,
                  height: 68,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(15, 10, 0, 15),
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
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
                            child: Text('Alerts',
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
                              child: Text('View archive of\napp alerts',
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
