import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_tracker/main.dart';

showMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Theme.of(context).focusColor,
    ),
  );
}

showInfo(String text, [Color? color, double? width]) {
  FToast fToast = FToast();
  fToast.init(navigatorKey.currentContext!);
  Widget box = Container(
    alignment: Alignment.center,
    width: width ?? 300,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
        color: color ?? Colors.red, borderRadius: BorderRadius.circular(15)),
    child: Text(text,
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        textAlign: TextAlign.center),
  );
  fToast.showToast(child: box, gravity: ToastGravity.BOTTOM);
}
