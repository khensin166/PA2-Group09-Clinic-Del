import 'package:clinicapp/Styles/colors.dart';
import 'package:flutter/material.dart';

void showMessage({String? message, BuildContext? context}) {
  ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    content: Card(
      color: primaryColor,
      elevation: 0,
      child: ListTile(
        leading: Icon(
          Icons.check_circle_outline,
          color: white,
        ),
        title: Text(
          message!,
          style: TextStyle(color: white, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text(
        //   'selamat anda berhasil login',
        //   style: TextStyle(color: white, fontWeight: FontWeight.bold),
        // ),
      ),
    ),
    margin: EdgeInsets.all(10),
  ));
}

void showErrorMessage({String? message, BuildContext? context}) {
  ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    content: Card(
      color: primaryColor,
      elevation: 0,
      child: ListTile(
        leading: Icon(
          Icons.cancel_outlined,
          color: white,
        ),
        title: Text(
          message!,
          style: TextStyle(color: white, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text(
        //   'selamat anda berhasil login',
        //   style: TextStyle(color: white, fontWeight: FontWeight.bold),
        // ),
      ),
    ),
    margin: EdgeInsets.all(10),
  ));
}
