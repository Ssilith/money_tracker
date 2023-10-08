import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:money_tracker/main_screens/exchange_rates.dart';

String url =
    "https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/ERT_BIL_EUR_D?format=JSON&lang=en&freq=D&statinfo=AVG&unit=NAC";

List<String> currencyToGet = ["CZK", "CHF"];

Future getEurostatCurrency() async {
  String currencies = getCurrencies();
  String dates = getDatesInRange();
  String apiCall = "$url$currencies$dates";

  var response = await http.get(
    Uri.parse(apiCall),
    headers: {'Accept-Charset': 'UTF-8'},
  );

  var decodedContent = utf8.decode(response.bodyBytes);
  var data = jsonDecode(decodedContent);
  return data;
}

Future<List<CurrencyData>> getEurCurrencyList() async {
  List<CurrencyData> currencyRate = [];
  var data = await getEurostatCurrency();

  for (var cur in currencyToGet) {
    CurrencyData currencyData = createCurrencyDataFromEurostatData(data, cur);
    currencyRate.add(currencyData);
  }
  return currencyRate;
}

CurrencyData createCurrencyDataFromEurostatData(
    Map<String, dynamic> json, String currency) {
  String fromCurrency = "EUR";
  String toCurrency = currency;

  int currencyStartingIndex = json['dimension']['currency']['category']['index']
          [currency] *
      json['size'][4];
  int numDates = json['size'][4];

  List<double> rates = [];
  for (int i = currencyStartingIndex;
      i < currencyStartingIndex + numDates;
      i++) {
    if (json['value'].containsKey(i.toString())) {
      rates.add(json['value'][i.toString()]);
    }
  }

  String latestRate = rates.last.toString();
  List<double> weeklyRates = rates;

  return CurrencyData(
    fromName: fromCurrency,
    toName: toCurrency,
    rate: latestRate,
    weekly: weeklyRates,
  );
}

String getCurrencies() {
  String currencies = "";
  for (var cur in currencyToGet) {
    currencies += "&currency=$cur";
  }
  return currencies;
}

String getDatesInRange() {
  DateTime endDate = DateTime.now();
  DateTime startDate = DateTime.now().subtract(const Duration(days: 15));
  DateTime currentDate = startDate;

  String dates = "";

  while (
      currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
    if (currentDate.weekday != DateTime.saturday &&
        currentDate.weekday != DateTime.sunday) {
      dates = "$dates&time=";
      dates = dates + DateFormat('yyyy-MM-dd').format(currentDate);
    }
    currentDate = currentDate.add(const Duration(days: 1));
  }
  return dates;
}
