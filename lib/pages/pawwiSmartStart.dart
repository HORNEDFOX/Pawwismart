import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../bloc/bloc/auth_bloc.dart';
import '../bloc/navigation/nav_bloc.dart';

Color buttonColor = const Color.fromRGBO(242, 244, 247, 0.7);
Color buttonTextColor = const Color.fromRGBO(114, 117, 168, 1);

class PSmartStart extends StatelessWidget {
  const PSmartStart({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
  return Container(
      padding:
      EdgeInsets.only(bottom: screenSize.height * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: 16, bottom: 0, left: 0, right: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                    icon: SvgPicture.asset(
                        "assets/images/facebook.svg"),
                    iconSize: 56,
                    onPressed: () {}),
                IconButton(
                    icon: SvgPicture.asset(
                        "assets/images/twitter.svg"),
                    iconSize: 56,
                    onPressed: () {}),
                IconButton(
                    icon: SvgPicture.asset(
                        "assets/images/google.svg"),
                    iconSize: 56,
                    onPressed: () {
                      _authenticateWithGoogle(context);
                    }),
              ],
            ),
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
                text: 'Or Connect With',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w400,
                )),
          ),
          SizedBox(height: 24),
          SizedBox(
            width: 296,
            height: 48,
            child: TextButton(
              onPressed: () {
                _pressLogInButton(context);
              },
              style: TextButton.styleFrom(
                  backgroundColor: buttonColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(100))),
              child: Column(
// Replace with a Row for horizontal icon + text
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("LOG IN",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.bold,
                        color: buttonTextColor,
                      )),
                  Text("With an Existing Account",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w300,
                        color: buttonTextColor,
                      )),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: 296,
            height: 48,
            child: TextButton(
                onPressed: () {
                  _pressSignUpButton(context);
                },
                child: Text('CREATE AN ACCOUNT',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.bold,
                      color: buttonTextColor,
                    )),
                style: TextButton.styleFrom(
                  backgroundColor: buttonColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(100)),
                )),
          ),
          SizedBox(height: 16),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                      text: 'Forgot password?',
                      style: new TextStyle(
                        fontSize: 13,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


void _authenticateWithGoogle(context) {
  BlocProvider.of<AuthBloc>(context).add(
    GoogleSignInRequested(),
  );
}

void _pressLogInButton(context) {
  BlocProvider.of<ButtonBloc>(context).add(
    LogInForm(),
  );
}

void _pressSignUpButton(context) {
  BlocProvider.of<ButtonBloc>(context).add(
    SignUpForm(),
  );
}
