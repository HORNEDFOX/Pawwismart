import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawwismart/pages/home.dart';
import 'package:pawwismart/pages/inputValidationMixin.dart';

import '../bloc/bloc/auth_bloc.dart';
import '../bloc/navigation/nav_bloc.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> with InputValidationMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Navigating to the dashboard screen if the user is authenticated
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home()));
          }
          if (state is AuthError) {
            // Showing the error message if the user has entered invalid credentials
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: Center(
        child: Container(
                width: MediaQuery.of(context).size.width / 1.2,
          padding: EdgeInsets.only(top: 20, bottom:20),
          margin: EdgeInsets.only(bottom: 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromRGBO(242, 244, 247, 0.85),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(148, 161, 187, 0.2),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome back!\nSign in to your PawwiSmart account", textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.5,
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
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            labelText: 'Email',
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
                                  color: Color.fromRGBO(255, 77, 120, 1),),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(255, 77, 120, 1),),
                            ),
                            errorStyle: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Open Sans',
                                color: Color.fromRGBO(255, 77, 120, 1),
                                fontWeight: FontWeight.w300),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _passwordController,
                          obscureText: true,
                          validator: (password) {
                            if (isPasswordValid(password!))
                              return null;
                            else
                              return 'Enter correct password';
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            labelText: 'Password',
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
                                  color: Color.fromRGBO(255, 77, 120, 1),),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(255, 77, 120, 1),),
                            ),
                            errorStyle: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Open Sans',
                                color: Color.fromRGBO(255, 77, 120, 1),
                                fontWeight: FontWeight.w300),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: FlatButton(
                          onPressed: () {
                            _authenticateWithEmailAndPassword(context);
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
                                  Color.fromRGBO(114, 117, 168, 1),
                                Color.fromRGBO(114, 117, 168, 1),
                              Color.fromRGBO(114, 117, 168, 1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              constraints: BoxConstraints(
                                  minHeight: 30, maxWidth: double.infinity),
                              child: Text(
                                "LOG IN",
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
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: FlatButton(
                          onPressed: () {
                            _pressBackHome(context);
                          },
                          padding: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(side: BorderSide(
                              color: Color.fromRGBO(114, 117, 168, 1),
                              width: 2,
                              style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(100),
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
                                "BACK HOME",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(114, 117, 168, 1),),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
              ),
        ),
      ),
        ),
    );
  }

  void _authenticateWithEmailAndPassword(context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignInRequested(_emailController.text, _passwordController.text),
      );
    }
  }
}

void _pressBackHome(context) {
  BlocProvider.of<ButtonBloc>(context).add(
    PSmartForm(),
  );
}
