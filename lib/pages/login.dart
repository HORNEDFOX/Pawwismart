import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pawwismart/pages/style.dart';

class LogIn extends StatelessWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.fitWidth,
            ),
          ),
          padding: EdgeInsets.only(left: 40, right: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05),
                    child: SvgPicture.asset("assets/images/Pawwi.svg", color: Colors.white,),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 2.15,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(148, 161, 187, 0.2),
                          spreadRadius: 0,
                          blurRadius: 2,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Log In",
                          style: TextStyle(
                            fontSize: 34,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w900,
                            color: Color.fromRGBO(151, 196, 232, 1),
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "Don't have an account? Create your\naccount, it takes less than a minute",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFieldApp(text: "Email", obscure: false),
                        SizedBox(
                          height: 16,
                        ),
                        TextFieldApp(text: "Password", obscure: true),
                        SizedBox(
                          height: 30,
                        ),
                        ButtonBlue(text: "LOG IN")
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
