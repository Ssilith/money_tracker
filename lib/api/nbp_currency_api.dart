import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:money_tracker/main_screens/exchange_rates.dart';

String url = "http://api.nbp.pl/api/exchangerates/rates/a/";
int resultsNumber = 10;

Future getNbpCurrency(String currency) async {
  String apiCall = "$url$currency/last/$resultsNumber/?format=json";
  var response = await http.get(Uri.parse(apiCall));
  var data = jsonDecode(response.body);
  return data["rates"];
}

List<String> currencyToGet = ["eur", "gbp", "chf", "usd"];

Future<List<CurrencyData>> getCurrencyList() async {
  List responsesList = [];
  List<CurrencyData> currencyRate = [];
  for (var cur in currencyToGet) {
    var res = await getNbpCurrency(cur);
    responsesList.add(res);
  }
  for (var i = 0; i < responsesList.length; i++) {
    CurrencyData currencyData = CurrencyData(
        fromName: "PLN",
        toName: currencyToGet[i].toUpperCase(),
        rate: responsesList[i][responsesList[i].length - 1]['mid'].toString(),
        weekly: List<double>.from(
            responsesList[i].map((element) => element['mid'])));
    currencyRate.add(currencyData);
  }
  return currencyRate;
}
