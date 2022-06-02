import 'package:flutter/material.dart';

void showToast(BuildContext context, String text){
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Color.fromRGBO(74, 85, 104, 1),
        content: Text(text),
        action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar, textColor: Colors.white,),
      )
  );
}