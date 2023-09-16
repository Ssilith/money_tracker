import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_tracker/main.dart';
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

  @override
  void initState() {
    super.initState();
    nbpCurrency = getCurrencyList();
    chosenCurrency = UserSimplePreferences.getChosenCurrency() ??
        ["PLN EUR", "PLN GBP", "PLN USD"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              surfaceTintColor: Theme.of(context).colorScheme.secondary,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              leading: Builder(
                builder: (BuildContext context) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage(),
                        ),
                      );
                    },
                    child: Icon(MdiIcons.arrowLeftCircle,
                        size: 40, color: Colors.white),
                  );
                },
              ),
              automaticallyImplyLeading: true,
              title: const Text("Kursy walut",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              centerTitle: true,
              floating: true,
              snap: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_vert,
                      size: 30, color: Colors.white),
                  onPressed: () {
                    chooseCurrencyRate(context);
                  },
                )
              ],
            ),
          ];
        },
        body: SingleChildScrollView(
          child: FutureBuilder<List<CurrencyData>>(
            future: nbpCurrency,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Indicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Błąd: ${snapshot.error}'));
              } else {
                currencyDataList = snapshot.data!;
                return Container(
                  padding: const EdgeInsets.all(10),
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
        ),
      ),
    );
  }

  Future chooseCurrencyRate(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter modalSetState) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 50,
                      child: chooseAll == true
                          ? Text(
                              "Odznacz wszystkie",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              "Wybierz wszystkie",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                    Checkbox(
                      activeColor: Theme.of(context).colorScheme.secondary,
                      value: chooseAll,
                      onChanged: (bool? value) async {
                        chooseAll = !chooseAll;
                        modalSetState(() {
                          if (chooseAll == true) {
                            chosenCurrency = getAllCurrencies();
                          } else {
                            chosenCurrency = [];
                          }
                        });
                        await UserSimplePreferences.setChosenCurrency(
                            chosenCurrency);
                        setState(() {});
                      },
                    )
                  ],
                ),
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
                "${currencyData.rate} ${currencyData.fromName == 'PLN' || currencyData.fromName == 'WIG 30' ? 'zł' : '€'}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          buildLineChart(currencyData),
        ],
      ),
    ),
  );
}

Widget buildLineChart(CurrencyData currencyData) {
  return SizedBox(
    height: 180,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              dotData: const FlDotData(show: true),
              spots: currencyData.weekly
                  .asMap()
                  .map((index, rate) =>
                      MapEntry(index, FlSpot(index.toDouble(), rate)))
                  .values
                  .toList(),
              isCurved: false,
              color: currencyData.fromName == 'PLN' ||
                      currencyData.fromName == 'WIG 30'
                  ? const Color.fromARGB(255, 237, 136, 34)
                  : const Color.fromARGB(255, 14, 54, 99),
              barWidth: 2.5,
              isStrokeCapRound: false,
              belowBarData: BarAreaData(
                show: true,
                color: (currencyData.fromName == 'PLN'
                        ? const Color.fromARGB(255, 244, 208, 161)
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
    ),
  );
}

getAllCurrencies() {
  return [
    'PLN EUR',
    'PLN GBP',
    'PLN CHF',
    'PLN USD',
  ];
}
