import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/global.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/resources/budget_service.dart';
import 'package:money_tracker/widgets/indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class BudgetWidget extends StatefulWidget {
  const BudgetWidget({super.key});

  @override
  State<BudgetWidget> createState() => _BudgetWidgetState();
}

class _BudgetWidgetState extends State<BudgetWidget> {
  Future? getCurrentBudget;

  @override
  void initState() {
    getCurrentBudget = BudgetService().getCurrentBudget(user.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              return const Center(child: Text('Nie znaleziono budżetu.'));
            } else {
              Map<String, dynamic> budget = snapshot.data!;
              double percentage =
                  budget['spentAmount'] / budget['budget']['amount'];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Theme.of(context).colorScheme.secondary,
                  // gradient: LinearGradient(
                  //     begin: Alignment.topRight,
                  //     end: Alignment.bottomLeft,
                  //     colors: gradientColors),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 35.0, vertical: 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Bieżący budżet",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 16,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              currencyFormat('PLN')
                                  .format(budget['leftAmount']),
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
                              lineHeight: 20.0,
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
                                style: const TextStyle(color: Colors.white),
                              ),
                              barRadius: const Radius.circular(8),
                              progressColor: Colors.green),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              currencyFormat('PLN')
                                  .format(budget['spentAmount']),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              currencyFormat('PLN')
                                  .format(budget['budget']['amount']),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Ważny do",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 16,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateFormat('yyyy-MM-dd').format(
                                  DateTime.parse(budget['budget']['endDate'])),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ]),
                ),
              );
            }
          }),
    );
  }
}
