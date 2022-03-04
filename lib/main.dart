import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pawwismart/pages/home.dart';
import 'package:pawwismart/pages/signup.dart';
import 'package:pawwismart/pages/login.dart';
import 'package:pawwismart/bloc/authenticationRepository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawwismart/bloc/blocObserver.dart';

Color buttonColor = const Color.fromRGBO(242, 244, 247, 0.7);
Color buttonTextColor = const Color.fromRGBO(114, 117, 168, 1);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;
  BlocOverrides.runZoned(
        () => runApp(BackgroundVideo(authenticationRepository: authenticationRepository)),
    blocObserver: AppBlocObserver(),
  );
}

class BackgroundVideo extends StatelessWidget {
  const BackgroundVideo({Key? key, required AuthenticationRepository authenticationRepository}) : _authenticationRepository = authenticationRepository, super(key: key);

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/dog.gif"),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            LoginWidget(),
          ],
        ),
      ),
      routes: {
        '/home': (context) => Home(),
        '/signup': (context) => SignUp(),
        '/login': (context) => LogIn(),
      },
    );
  }
}

class LoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(159, 161, 212, 0.65),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: screenSize.height * 0.15),
              child: SvgPicture.asset("assets/images/Pawwi.svg"),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: screenSize.height * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
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
                              icon:
                                  SvgPicture.asset("assets/images/twitter.svg"),
                              iconSize: 56,
                              onPressed: () {}),
                          IconButton(
                              icon:
                                  SvgPicture.asset("assets/images/google.svg"),
                              iconSize: 56,
                              onPressed: () {}),
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
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: buttonColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100))),
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
                            Navigator.pushReplacementNamed(context, '/login');
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
                                borderRadius: BorderRadius.circular(100)),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
