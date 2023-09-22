import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/global.dart';
import 'package:money_tracker/main_summary/pie_chart.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/resources/budget_service.dart';
import 'package:money_tracker/widgets/indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class BalanceBox extends StatefulWidget {
  const BalanceBox({super.key});

  @override
  State<BalanceBox> createState() => _BalanceBoxState();
}

class _BalanceBoxState extends State<BalanceBox> {
  Future? getCurrentBudget;

  @override
  void initState() {
    getCurrentBudget = BudgetService().getCurrentBudget(user.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
          future: getCurrentBudget,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Indicator();
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text('Wystąpił błąd. Spróbuj ponownie później.'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('Nie znaleziono transakcji.'));
            } else {
              var data = snapshot.data!;
              double percentage =
                  data['spentAmount'] / data['budget']['amount'];
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    width: size.width,
                    height: 400,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Bieżący budżet",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                currencyFormat('PLN')
                                    .format(data['leftAmount']),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: LinearPercentIndicator(
                              animation: true,
                              lineHeight: 25,
                              animationDuration: 2500,
                              padding: EdgeInsets.zero,
                              percent: percentage < 0
                                  ? 0
                                  : percentage > 1
                                      ? 1
                                      : percentage,
                              backgroundColor: Colors.white.withOpacity(0.25),
                              center: Text(
                                "${percentage < 0 ? 0.00 : (percentage * 100).toStringAsFixed(2)}%",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              barRadius: const Radius.circular(8),
                              progressColor:
                                  const Color.fromARGB(255, 38, 174, 108),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                currencyFormat('PLN')
                                    .format(data['spentAmount']),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                currencyFormat('PLN')
                                    .format(data['budget']['amount']),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Divider(color: Colors.white.withOpacity(0.2)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Podsumowanie",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 16)),
                              Text(
                                  DateFormat('yyyy-MM-dd').format(
                                      DateTime.parse(
                                          data['budget']['endDate'])),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    child: ClipPath(
                      clipper: WaveClipperTwo(reverse: true),
                      child: Container(
                        color: const Color.fromARGB(134, 40, 147, 95),
                        width: size.width,
                        height: 95,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: ClipPath(
                      clipper: WaveClipperOne(reverse: true),
                      child: Container(
                        height: 80,
                        width: size.width,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(7.0),
                              bottomRight: Radius.circular(27.0)),
                          color: Color.fromARGB(255, 38, 174, 108),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    bottom: 100,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 120,
                        child: PieChartBox(categories: data['categories']),
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
