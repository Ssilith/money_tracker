import 'package:flutter/material.dart';
import 'package:http/retry.dart';
import 'package:intl/intl.dart';

List<Color> gradientColors = const [
  Color.fromARGB(255, 0, 162, 108),
  Color.fromARGB(255, 0, 184, 121),
  Color.fromARGB(255, 0, 181, 212),
  Color.fromARGB(255, 253, 191, 94),
  Color.fromARGB(255, 253, 223, 158)
];

List<String> months = [
  'Styczeń',
  'Luty',
  'Marzec',
  'Kwiecień',
  'Maj',
  'Czerwiec',
  'Lipiec',
  'Sierpień',
  'Wrzesień',
  'Październik',
  'Listopad',
  'Grudzień'
];

Map<String, int> monthNameToNumber = {
  'Styczeń': 1,
  'Luty': 2,
  'Marzec': 3,
  'Kwiecień': 4,
  'Maj': 5,
  'Czerwiec': 6,
  'Lipiec': 7,
  'Sierpień': 8,
  'Wrzesień': 9,
  'Październik': 10,
  'Listopad': 11,
  'Grudzień': 12
};

NumberFormat currencyFormat(String currency) {
  String localCurrency = currency == "PLN" ? "pl_PL" : "it_IT";
  return NumberFormat.simpleCurrency(locale: localCurrency);
}

MaterialColor getMaterialColor(Color color) {
  final int red = color.red;
  final int green = color.green;
  final int blue = color.blue;

  final Map<int, Color> shades = {
    50: Color.fromRGBO(red, green, blue, .1),
    100: Color.fromRGBO(red, green, blue, .2),
    200: Color.fromRGBO(red, green, blue, .3),
    300: Color.fromRGBO(red, green, blue, .4),
    400: Color.fromRGBO(red, green, blue, .5),
    500: Color.fromRGBO(red, green, blue, .6),
    600: Color.fromRGBO(red, green, blue, .7),
    700: Color.fromRGBO(red, green, blue, .8),
    800: Color.fromRGBO(red, green, blue, .9),
    900: Color.fromRGBO(red, green, blue, 1),
  };

  return MaterialColor(color.value, shades);
}

List<String> chosenCurrency = <String>[];

List<String> chosenWidgets = <String>[];

late RetryClient client;
