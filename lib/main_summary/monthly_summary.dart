import 'package:flutter/material.dart';
import 'package:money_tracker/global.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/resources/transaction_service.dart';
import 'package:money_tracker/widgets/indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MonthlySummary extends StatefulWidget {
  const MonthlySummary({super.key});

  @override
  State<MonthlySummary> createState() => _MonthlySummaryState();
}

class _MonthlySummaryState extends State<MonthlySummary> {
  Future? getMonthlySummary;

  @override
  void initState() {
    super.initState();
    getMonthlySummary = TransactionService().getMonthlySummary(user.id!);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(249, 243, 246, 254),
        borderRadius: BorderRadius.circular(10),
      ),
      width: size.width,
      child: FutureBuilder(
          future: getMonthlySummary,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Indicator();
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text('Wystąpił błąd. Spróbuj ponownie później.'));
            } else if (snapshot.data!.isEmpty) {
              return const Center(child: Text('Nie znaleziono danych.'));
            } else {
              Map summ = snapshot.data!;
              double costs = summ['costs'] + 0.0;
              double income = summ['income'] + 0.0;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Rozliczenie miesięczne",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  const SizedBox(height: 10),
                  if (costs != 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currencyFormat("PLN").format(costs),
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        const Text(
                          "KOSZTY",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  if (costs != 0)
                    SfLinearGauge(
                      showLabels: false,
                      showTicks: false,
                      minimum: 0,
                      maximum: costs > income ? costs : income,
                      barPointers: [
                        LinearBarPointer(
                          edgeStyle: LinearEdgeStyle.bothCurve,
                          thickness: 10,
                          value: costs,
                          color: const Color.fromARGB(255, 241, 81, 70),
                        ),
                      ],
                    ),
                  const SizedBox(height: 10),
                  if (income != 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currencyFormat("PLN").format(income),
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        const Text(
                          "PRZYCHODY",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  if (income != 0)
                    SfLinearGauge(
                      showLabels: false,
                      showTicks: false,
                      minimum: 0,
                      maximum: costs > income ? costs : income,
                      barPointers: [
                        LinearBarPointer(
                          edgeStyle: LinearEdgeStyle.bothCurve,
                          thickness: 10,
                          value: income,
                          color: const Color.fromARGB(255, 38, 174, 108),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currencyFormat("PLN").format((costs - income).abs()),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        costs > income ? "STRATA" : "ZYSK",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              );
            }
          }),
    );
  }
}
