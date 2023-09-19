import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:money_tracker/global.dart';
import 'package:money_tracker/main_summary/pie_chart.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/resources/transaction_service.dart';
import 'package:money_tracker/widgets/indicator.dart';

class BalanceBox extends StatefulWidget {
  const BalanceBox({super.key});

  @override
  State<BalanceBox> createState() => _BalanceBoxState();
}

class _BalanceBoxState extends State<BalanceBox> {
  Future? lastWeekExpenses;

  @override
  void initState() {
    lastWeekExpenses = TransactionService().getLastWeekTopCategories(user.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
          future: lastWeekExpenses,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Indicator();
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text('Wystąpił błąd. Spróbuj ponownie później.'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('Nie znaleziono transakcji.'));
            } else {
              Map<String, dynamic> categories = snapshot.data!;
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    width: size.width,
                    height: 380,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Wydatki",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 16)),
                              Text(
                                  currencyFormat('PLN')
                                      .format(categories['totalExpense']),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Divider(color: Colors.white.withOpacity(0.2)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Podsumowanie",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text("Ostatnie 7 dni",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 14)),
                            ],
                          ),
                          PieChartBox(snapshotData: categories),
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
                ],
              );
            }
          }),
    );
  }
}
