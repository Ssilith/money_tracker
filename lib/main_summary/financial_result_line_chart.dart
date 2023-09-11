import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:money_tracker/example_data.dart';
import 'package:money_tracker/global.dart';

class FinancialResultLineChart extends StatefulWidget {
  const FinancialResultLineChart({super.key});

  @override
  State<FinancialResultLineChart> createState() =>
      _FinancialResultLineChartState();
}

class _FinancialResultLineChartState extends State<FinancialResultLineChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: transparentOnGradient(),
      height: 380,
      width: 600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Wynik finansowy",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          const SizedBox(height: 10),
          SfCartesianChart(
            tooltipBehavior: TooltipBehavior(enable: true),
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
                numberFormat: NumberFormat.compactCurrency(
                    decimalDigits: 2, locale: 'pl_PL', symbol: '')),
            series: [
              LineSeries<MonthResult, String>(
                  name: "Przychody",
                  color: Colors.green,
                  dataSource: financialDataTamplate,
                  xValueMapper: (MonthResult data, _) => data.monthName,
                  yValueMapper: (MonthResult data, _) => data.revenue,
                  markerSettings: const MarkerSettings(isVisible: true),
                  enableTooltip: true),
              // LineSeries<MonthResult, String>(
              //     name: "Przychody 2022",
              //     color: const Color.fromARGB(255, 159, 219, 161),
              //     dataSource: financialDataTamplate,
              //     xValueMapper: (MonthResult data, _) => data.monthName,
              //     yValueMapper: (MonthResult data, _) => data.prevRevenue,
              //     markerSettings: const MarkerSettings(isVisible: true),
              //     enableTooltip: true),
              LineSeries<MonthResult, String>(
                  name: "Koszty",
                  color: Colors.red,
                  dataSource: financialDataTamplate,
                  xValueMapper: (MonthResult data, _) => data.monthName,
                  yValueMapper: (MonthResult data, _) => data.cost,
                  markerSettings: const MarkerSettings(isVisible: true),
                  enableTooltip: true),
              // LineSeries<MonthResult, String>(
              //     name: "Koszty 2022",
              //     color: const Color.fromARGB(255, 255, 139, 131),
              //     dataSource: financialDataTamplate,
              //     xValueMapper: (MonthResult data, _) => data.monthName,
              //     yValueMapper: (MonthResult data, _) => data.prevCost,
              //     markerSettings: const MarkerSettings(isVisible: true),
              //     enableTooltip: true),
            ],
          )
        ],
      ),
    );
  }
}
