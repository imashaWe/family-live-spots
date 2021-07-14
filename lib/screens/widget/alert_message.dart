import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';

import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';

class AlertMessage {
  static void snakbarError(
          {required String message, required GlobalKey<ScaffoldState> key}) =>
      _setSnack(key, message, true);

  static void snakbarSuccess(
          {required String message, required GlobalKey<ScaffoldState> key}) =>
      _setSnack(key, message, false);

  static void topSnackbarError(
          {required String message, required BuildContext context}) =>
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: message,
        ),
      );

  static void topSnackbarSuccess(
          {required String message, required BuildContext context}) =>
      showTopSnackBar(
        context,
        CustomSnackBar.success(
          message: message,
        ),
      );

  static void _setSnack(GlobalKey<ScaffoldState> key, String m, bool isError) {
    final SnackBar snackBar = SnackBar(
      duration: Duration(seconds: 10),
      content: Text(
        m,
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
    );
    key.currentState?.showSnackBar(snackBar);
  }

  // static void toastError({String message}) {
  //   Fluttertoast.showToast(
  //       msg: message,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.red,
  //       fontSize: 16.0);
  // }

  // static void toastSuccess({String message}) {
  //   Fluttertoast.showToast(
  //       msg: message,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.green,
  //       textColor: Colors.white,
  //       fontSize: 16.0);
  // }
}
