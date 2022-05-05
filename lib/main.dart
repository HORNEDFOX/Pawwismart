import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawwismart/bloc/bloc/auth_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pawwismart/bloc/petBloc/pet_bloc.dart';
import 'package:pawwismart/data/repositories/pet_repository.dart';
import 'package:pawwismart/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pawwismart/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawwismart/pages/login.dart';
import 'package:pawwismart/pages/pawwiSmartStart.dart';
import 'package:pawwismart/pages/signup.dart';

import 'bloc/navigation/nav_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
            ),
          ),
        ],
        child: MaterialApp(
          home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                   return Home();
                }
                return BackgroundVideo();
              }),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

class BackgroundVideo extends StatelessWidget {
  const BackgroundVideo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Loading) {
              // Showing the loading indicator while the user is signing in
              return const Center(
                child: SafeArea(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromRGBO(114, 117, 168, 1)),
                  ),
                ),
              );
            }
            return Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/dog.gif"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                BlocProvider(
                  create: (context) => ButtonBloc(NoPressAuthButton()),
                  child: LoginWidget(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class LoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromRGBO(159, 161, 212, 0.65),
        body: SingleChildScrollView(
          child: Container(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: screenSize.height * 0.15),
                    child: SvgPicture.asset("assets/images/Pawwi.svg"),
                  ),
                  BlocBuilder<ButtonBloc, ButtonState>(
                    builder: (context, state) {
                      if (state is NoPressAuthButton) {
                        return PSmartStart();
                      }
                      if (state is PressLogInButton) {
                        return LogIn();
                      }
                      if (state is PressSignUpButton) {
                        return SignUp();
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
