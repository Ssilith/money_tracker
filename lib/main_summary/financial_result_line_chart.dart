import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/global.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/resources/transaction_service.dart';
import 'package:money_tracker/widgets/indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FinancialResultLineChart extends StatefulWidget {
  const FinancialResultLineChart({super.key});

  @override
  State<FinancialResultLineChart> createState() =>
      _FinancialResultLineChartState();
}

class _FinancialResultLineChartState extends State<FinancialResultLineChart> {
  Future? getYearlySummary;
  int currentMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    getYearlySummary = TransactionService().getYearlySummary(user.id!);
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
          future: getYearlySummary,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Indicator();
            } else if (snapshot.hasError) {
              return Center(child: Text('Błąd: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nie znaleziono danych.'));
            } else {
              List<Map> currYearFinancies = List<Map>.from(snapshot.data!);
              List<Map> filteredFinancies = currYearFinancies.where((element) {
                return months.indexOf(element['month']) < currentMonth;
              }).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Wynik finansowy",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  const SizedBox(height: 10),
                  SfCartesianChart(
                    tooltipBehavior: TooltipBehavior(enable: true),
                    legend: Legend(
                        isVisible: true, position: LegendPosition.bottom),
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(
                        numberFormat: NumberFormat.compactCurrency(
                            decimalDigits: 2, locale: 'pl_PL', symbol: '')),
                    series: [
                      LineSeries(
                          name: "Przychody",
                          color: const Color.fromARGB(255, 38, 174, 108),
                          dataSource: filteredFinancies,
                          xValueMapper: (Map data, _) =>
                              data['month'].toString().substring(0, 3),
                          yValueMapper: (Map data, _) => data['income'],
                          markerSettings: const MarkerSettings(isVisible: true),
                          enableTooltip: true),
                      LineSeries(
                          name: "Koszty",
                          color: const Color.fromARGB(255, 241, 81, 70),
                          dataSource: filteredFinancies,
                          xValueMapper: (Map data, _) =>
                              data['month'].toString().substring(0, 3),
                          yValueMapper: (Map data, _) => data['costs'],
                          markerSettings: const MarkerSettings(isVisible: true),
                          enableTooltip: true),
                    ],
                  )
                ],
              );
            }
          }),
    );
  }
}
