import 'package:flutter/material.dart';
import 'package:http/retry.dart';
import 'package:intl/intl.dart';

BoxDecoration withShadow([Color? color, int a = 255]) {
  return BoxDecoration(
    color: color ?? Colors.white,
    boxShadow: [
      BoxShadow(
        color: Color.fromARGB(a, 148, 148, 148),
        offset: const Offset(5, 5),
        blurRadius: 10,
      ),
    ],
    borderRadius: BorderRadius.circular(8),
  );
}

BoxDecoration transparentOnGradient([Color? color]) {
  return BoxDecoration(
    color: color ?? Colors.white38,
    borderRadius: BorderRadius.circular(8),
  );
}

List<Color> gradientColors = [
  Color.fromARGB(255, 0, 162, 108),
  Color.fromARGB(255, 0, 184, 121),
  Color.fromARGB(255, 0, 181, 212),
  Color.fromARGB(255, 253, 191, 94),
  Color.fromARGB(255, 253, 223, 158)
];

NumberFormat currencyFormat(String currency) {
  String localCurrency = currency == "PLN" ? "pl_PL" : "it_IT";
  return NumberFormat.simpleCurrency(locale: localCurrency);
}

List<String> chosenCurrency = <String>[];

late RetryClient client;
