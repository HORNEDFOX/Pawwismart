import 'package:flutter/material.dart';

class TextFieldApp extends StatelessWidget {
  const TextFieldApp({Key? key, required this.text, required this.obscure})
      : super(key: key);

  final String text;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      height: 50,
      child: TextField(
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: text,
          labelStyle: TextStyle(
              fontSize: 15,
              fontFamily: 'Open Sans',
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w400),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color.fromRGBO(151, 196, 232, 1)),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
      ),
    );
  }
}

class ButtonBlue extends StatelessWidget {
  const ButtonBlue({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width / 1.5,
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
            constraints:
                BoxConstraints(minHeight: 30, maxWidth: double.infinity),
            child: Text(
              text,
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
    );
  }
}
