import 'package:flutter/material.dart';
import 'package:money_tracker/api/eurostat_currency_api.dart';
import 'package:money_tracker/resources/user_simple_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:money_tracker/widgets/indicator.dart';
import '../api/nbp_currency_api.dart';
import '../global.dart';
import 'package:collection/collection.dart';

late Future<List<CurrencyData>> nbpCurrency;
bool chooseAll = false;

class CurrencyData {
  final String fromName;
  final String? toName;
  final String rate;
  final List<double> weekly;

  CurrencyData(
      {required this.fromName,
      this.toName,
      required this.rate,
      required this.weekly});
}

class ExchangeRates extends StatefulWidget {
  const ExchangeRates({super.key});

  @override
  State<ExchangeRates> createState() => _ExchangeRatesState();
}

class _ExchangeRatesState extends State<ExchangeRates> {
  List<CurrencyData> currencyDataList = [];
  Future<List<CurrencyData>>? combinedCurrency;

  @override
  void initState() {
    super.initState();
    combinedCurrency = getCurrenciesCombined();
    chosenCurrency = UserSimplePreferences.getChosenCurrency() ??
        ["EUR PLN", "GBP PLN", "USD PLN"];
  }

  Future<List<CurrencyData>> getCurrenciesCombined() async {
    List<CurrencyData> nbpCurrency = await getCurrencyList();
    List<CurrencyData> eurCurrency = await getEurCurrencyList();
    return nbpCurrency + eurCurrency;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Kursy walut",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary)),
                    IconButton(
                        onPressed: () => chooseCurrencyRate(context),
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.black,
                          size: 30,
                        ))
                  ],
                ),
              ),
              FutureBuilder<List<CurrencyData>>(
                future: combinedCurrency,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Indicator());
                  } else if (snapshot.hasError || snapshot.data!.isEmpty) {
                    return const Center(
                        child:
                            Text('Wystąpił błąd. Spróbuj ponownie później.'));
                  } else {
                    currencyDataList = snapshot.data!;
                    return Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      width: 600,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...chosenCurrency
                              .map<Widget?>((currency) {
                                var currencyData =
                                    currencyDataList.firstWhereOrNull((data) {
                                  var currentPair = data.fromName;
                                  if (data.toName != null) {
                                    currentPair += " ${data.toName}";
                                  }
                                  return currentPair == currency;
                                });

                                return currencyData != null
                                    ? buildCurrencyCard(currencyData, context)
                                    : null;
                              })
                              .whereType<Widget>()
                              .toList(),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ));
  }

  Future chooseCurrencyRate(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter modalSetState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("Wybierz waluty",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: currencyDataList.length,
                      itemBuilder: (context, index) {
                        String currencyPair = currencyDataList[index].fromName;
                        if (currencyDataList[index].toName != null) {
                          currencyPair += " ${currencyDataList[index].toName}";
                        }
                        bool isSelected = chosenCurrency.contains(currencyPair);
                        return CheckboxListTile(
                          activeColor: Theme.of(context).colorScheme.secondary,
                          value: isSelected,
                          title: Text(currencyPair),
                          onChanged: (bool? value) async {
                            modalSetState(() {
                              if (value!) {
                                if (!chosenCurrency.contains(currencyPair)) {
                                  chosenCurrency.add(currencyPair);
                                }
                              } else {
                                chosenCurrency.remove(currencyPair);
                              }
                            });
                            await UserSimplePreferences.setChosenCurrency(
                                chosenCurrency);
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }
}

Widget buildCurrencyCard(CurrencyData currencyData, BuildContext context) {
  return Card(
    margin: const EdgeInsets.only(top: 15),
    shadowColor: Colors.white,
    surfaceTintColor: const Color.fromARGB(255, 33, 69, 213),
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${currencyData.fromName} ${currencyData.toName != null ? "- " : ""} ${currencyData.toName ?? ""}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                "${currencyData.rate} ${currencyData.toName == 'PLN' ? 'zł' : currencyData.toName == 'CZK' ? 'Kč' : currencyData.toName == 'CHF' ? 'Fr.' : '€'}",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          buildLineChart(currencyData, context),
        ],
      ),
    ),
  );
}

Widget buildLineChart(CurrencyData currencyData, BuildContext context) {
  return SizedBox(
    height: 180,
    child: LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            dotData: const FlDotData(show: false),
            spots: currencyData.weekly
                .asMap()
                .map((index, rate) =>
                    MapEntry(index, FlSpot(index.toDouble(), rate)))
                .values
                .toList(),
            isCurved: false,
            color: currencyData.toName == 'PLN'
                ? Theme.of(context).colorScheme.secondary
                : const Color.fromARGB(255, 14, 54, 99),
            barWidth: 2.5,
            isStrokeCapRound: false,
            belowBarData: BarAreaData(
              show: true,
              color: (currencyData.toName == 'PLN'
                      ? const Color.fromARGB(255, 38, 174, 108)
                      : const Color.fromARGB(255, 89, 120, 169))
                  .withOpacity(0.3),
            ),
          ),
        ],
        lineTouchData: const LineTouchData(
            touchTooltipData:
                LineTouchTooltipData(tooltipBgColor: Colors.white)),
      ),
    ),
  );
}

getAllCurrencies() {
  return [
    'EUR PLN',
    'GBP PLN',
    'CHF PLN',
    'USD PLN',
    'EUR CHF',
    'EUR CZK',
  ];
}
