import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FlexiableAppBar extends StatelessWidget {

  final double appBarHeight = 30.0;

  const FlexiableAppBar();

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery
        .of(context)
        .padding
        .top;

    return new Container(
      padding: const EdgeInsets.fromLTRB(0,14,0,0),
      color: Color.fromRGBO(253, 253, 253, 1),
      child: Column(
        children: [
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.fromLTRB(15,0,0,0),
                  child: Text('Hello, ',
                      style: TextStyle(
                        color: Color.fromRGBO(74, 85, 104, 1),
                        fontSize: 30,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w900,)
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text('Amanda',
                      style: TextStyle(
                        color: Color.fromRGBO(151, 196, 232, 1),
                        fontSize: 30,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w900,)
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(130,0,3,0),
                  child: SvgPicture.asset(
                      "assets/images/bellPinFill.svg"
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0,0,3,0),
                  child: SvgPicture.asset(
                      "assets/images/menu.svg"
                  ),
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
                  margin: EdgeInsets.fromLTRB(15,10,0,15),
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
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
                      SvgPicture.asset(
                          "assets/images/mapHome.svg"
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(12,0,0,0),
                            width: 110,
                            height: 24,
                            alignment: Alignment.centerLeft,
                            child: Text('Locations',
                                style: TextStyle(
                                  color: Color.fromRGBO(74, 85, 104, 1),
                                  fontSize: 24,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w900,)),
                          ),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(12,0,0,0),
                              width: 110,
                              height: 56,
                              alignment: Alignment.centerLeft,
                              child: Text('View the location of my pets',
                                  style: TextStyle(
                                    color: Color.fromRGBO(74, 85, 104, 1),
                                    fontSize: 12,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w300,)),
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
                  margin: EdgeInsets.fromLTRB(15,10,0,15),
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
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
                      SvgPicture.asset(
                          "assets/images/calendarHome.svg"
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(12,0,0,0),
                            width: 110,
                            height: 24,
                            alignment: Alignment.centerLeft,
                            child: Text('Archive',
                                style: TextStyle(
                                  color: Color.fromRGBO(74, 85, 104, 1),
                                  fontSize: 24,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w900,)),
                          ),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(12,0,0,0),
                              width: 110,
                              height: 56,
                              alignment: Alignment.centerLeft,
                              child: Text('View the archive of pet walks',
                                  style: TextStyle(
                                    color: Color.fromRGBO(74, 85, 104, 1),
                                    fontSize: 12,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w300,)),
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