import 'package:flutter/material.dart';
import 'package:money_tracker/global.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/resources/transaction_service.dart';
import 'package:money_tracker/widgets/indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class IncomeRadailBar extends StatefulWidget {
  const IncomeRadailBar({super.key});

  @override
  State<IncomeRadailBar> createState() => _IncomeRadailBarState();
}

class _IncomeRadailBarState extends State<IncomeRadailBar> {
  Future? getMonthCost;
  List<bool> seriesVisibility = [true, true];
  List<double> labelOpacity = [1.0, 1.0];
  final animationDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    getMonthCost =
        TransactionService().getMonthlySummaryCostAndIncome(user.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 270,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(249, 243, 246, 254),
          borderRadius: BorderRadius.circular(10),
        ),
        child: FutureBuilder(
            future: getMonthCost,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Indicator();
              } else if (snapshot.hasError) {
                return Center(child: Text('Błąd: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Nie znaleziono danych.'));
              } else {
                Map monthCost = snapshot.data!;
                double averageIncome =
                    monthCost['monthlyAverage']['averageIncome'] + 0.0;
                double thisMonthIncome = monthCost['thisMonth']['income'] + 0.0;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    const Text(
                      "PORÓWNANIE PRZYCHODÓW",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    AspectRatio(
                      aspectRatio: 1.7,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SfCircularChart(
                            legend: Legend(
                                shouldAlwaysShowScrollbar: false,
                                isVisible: true,
                                textStyle: const TextStyle(fontSize: 16)),
                            onLegendTapped: (LegendTapArgs args) {
                              setState(() {
                                labelOpacity[args.pointIndex!] =
                                    labelOpacity[args.pointIndex!] == 1.0
                                        ? 0.0
                                        : 1.0;
                              });
                            },
                            series: <CircularSeries>[
                              RadialBarSeries<IncomeData, String>(
                                dataSource: [
                                  IncomeData(
                                      months[DateTime.now().month - 1],
                                      thisMonthIncome,
                                      const Color.fromARGB(255, 38, 174, 108)),
                                  IncomeData('Średnia', averageIncome,
                                      Theme.of(context).colorScheme.secondary),
                                ],
                                pointColorMapper: (IncomeData data, _) =>
                                    data.color,
                                xValueMapper: (IncomeData data, _) => data.name,
                                yValueMapper: (IncomeData data, _) =>
                                    data.value,
                                pointRadiusMapper: (IncomeData data, _) =>
                                    data.name ==
                                            months[DateTime.now().month - 1]
                                        ? '60%'
                                        : '100%',
                                maximumValue: averageIncome * 0.9999,
                                cornerStyle: CornerStyle.bothCurve,
                                trackColor:
                                    const Color.fromRGBO(212, 214, 216, 1),
                                radius: '100%',
                                gap: '7%',
                              ),
                            ],
                          ),
                          if (seriesVisibility[0])
                            Positioned(
                              left: 90,
                              child: AnimatedOpacity(
                                opacity: labelOpacity[0],
                                duration: animationDuration,
                                child: Text(
                                  currencyFormat("PLN").format(thisMonthIncome),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          if (seriesVisibility[1])
                            Positioned(
                              top: 10,
                              child: AnimatedOpacity(
                                opacity: labelOpacity[1],
                                duration: animationDuration,
                                child: Text(
                                  currencyFormat("PLN").format(averageIncome),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            }));
  }
}

class IncomeData {
  final String name;
  final double value;
  final Color color;

  IncomeData(this.name, this.value, this.color);
}
