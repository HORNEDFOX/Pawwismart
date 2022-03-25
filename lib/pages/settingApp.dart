import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/bloc/auth_bloc.dart';

class SettingApp extends StatelessWidget {
  const SettingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar:  AppBar(
    // <-- app bar for logo
    toolbarHeight: 0,
    elevation: 0.0,
    backgroundColor: Color.fromRGBO(74, 85, 104, 1),
  ),
  body: Container(
  padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
    child: Column(
    children: [
  Container(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: <Widget>[
  Row(
  children: [
  Container(
  alignment: Alignment.topLeft,
    padding: EdgeInsets.fromLTRB(15,0,0,0),
    child: Text('Setting App',
        style: TextStyle(
          color: Color.fromRGBO(74, 85, 104, 1),
          fontSize: 30,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w900,)
    ),
  ),
      ],
  ),
      Row(
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(0,0,0,0),
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
                    onTap: () {},
                  ),
                ),
              )
          ),
      Container(
          padding: const EdgeInsets.fromLTRB(0,0,10,0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Material(
              color: Color.fromRGBO(255, 255, 255, 1),
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(2),
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
          ], ),
      ],
    ),
    ),
      Container(
        padding: const EdgeInsets.fromLTRB(15,10,15,10),
        child: TextFormField(
          keyboardType: TextInputType.text,
          obscureText: false,
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
              borderSide:
              BorderSide(color: Color.fromRGBO(114, 117, 168, 0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Color.fromRGBO(114, 117, 168, 1)),
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
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.fromLTRB(15,0,15,10),
        child: TextFormField(
          keyboardType: TextInputType.text,
          obscureText: false,
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
              borderSide:
              BorderSide(color: Color.fromRGBO(114, 117, 168, 0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Color.fromRGBO(114, 117, 168, 1)),
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
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
        ),
      ),
      Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.fromLTRB(15,10,0,10),
        child: Text('General Settings',
            style: TextStyle(
              color: Color.fromRGBO(151, 196, 232, 1),
              fontSize: 30,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w900,)
        ),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(0,5,15,5),
        child: Row(
          mainAxisAlignment:  MainAxisAlignment.spaceBetween,
          children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.fromLTRB(15,0,0,3),
          child: Text('Lost Pets',
              style: TextStyle(
                color: Color.fromRGBO(74, 85, 104, 1),
                fontSize: 20,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w900,)
          ),
      ),
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.fromLTRB(15,0,0,0),
              child: Text('Let me know if there is a lost pet\nin the vicinity',
                  style: TextStyle(
                    color: Color.fromRGBO(74, 85, 104, 1),
                    fontSize: 16,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w300,)
              ),
            )
            ],
        ),
            CupertinoSwitch(
              activeColor: Color.fromRGBO(151, 196, 232, 1), /// Пользовательские цвета синие
              trackColor: Color.fromRGBO(74, 85, 104, 1),
              onChanged: null, value: true,
            ),
      ],
        ),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(0,10,15,5),
        child: Row(
          mainAxisAlignment:  MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.fromLTRB(15,0,0,3),
                  child: Text('Password',
                      style: TextStyle(
                        color: Color.fromRGBO(74, 85, 104, 1),
                        fontSize: 20,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w900,)
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.fromLTRB(15,0,0,0),
                  child: Text('Change account password',
                      style: TextStyle(
                        color: Color.fromRGBO(74, 85, 104, 1),
                        fontSize: 16,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w300,)
                  ),
                )
              ],
            ),
            Container(
              height: 36,
              width: 36,
              child: FlatButton(
                onPressed: () {
                },
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
                    child: Text(
                      ">",
                      style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.fromLTRB(15,0,0,0),
        child: Text('Remove',
            style: TextStyle(
              color: Color.fromRGBO(74, 85, 104, 1),
              fontSize: 30,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w900,)
        ),
      ),
    ],
  ),
  ),
    );
  }
}
