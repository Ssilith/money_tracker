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

List<Color> gradientColors = const [
  Color.fromARGB(255, 254, 216, 247),
  Color.fromARGB(255, 255, 236, 251),
  Color.fromARGB(255, 240, 240, 232),
  Color.fromARGB(255, 221, 232, 255),
  Color.fromARGB(255, 196, 221, 254)
];

NumberFormat currencyFormat(String currency) {
  String localCurrency = currency == "PLN" ? "pl_PL" : "it_IT";
  return NumberFormat.simpleCurrency(locale: localCurrency);
}

late RetryClient client;
