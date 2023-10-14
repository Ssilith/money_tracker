import 'package:flutter/material.dart';
import 'package:money_tracker/global.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/resources/transaction_service.dart';
import 'package:money_tracker/widgets/indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CostGauge extends StatefulWidget {
  const CostGauge({super.key});

  @override
  State<CostGauge> createState() => _CostGaugeState();
}

class _CostGaugeState extends State<CostGauge> {
  double gaugeWidth = 60;
  Future? getMonthCost;

  @override
  void initState() {
    super.initState();
    getMonthCost =
        TransactionService().getMonthlySummaryCostAndIncome(user.id!);
  }

  List<GaugeRange> gaugeRanges(double average) {
    return [
      GaugeRange(
        startWidth: gaugeWidth,
        endWidth: gaugeWidth,
        startValue: 0,
        endValue: 0.4 * average,
        color: const Color.fromARGB(255, 11, 93, 55),
      ),
      GaugeRange(
        startWidth: gaugeWidth,
        endWidth: gaugeWidth,
        startValue: 0.4 * average,
        endValue: 0.8 * average,
        color: const Color.fromARGB(255, 108, 165, 137),
      ),
      GaugeRange(
        startWidth: gaugeWidth,
        endWidth: gaugeWidth,
        startValue: 0.8 * average,
        endValue: 1.2 * average,
        color: const Color.fromARGB(255, 255, 247, 138),
      ),
      GaugeRange(
        startWidth: gaugeWidth,
        endWidth: gaugeWidth,
        startValue: 1.2 * average,
        endValue: 1.6 * average,
        color: const Color.fromARGB(255, 246, 172, 118),
      ),
      GaugeRange(
        startWidth: gaugeWidth,
        endWidth: gaugeWidth,
        startValue: 1.6 * average,
        endValue: 2 * average,
        color: const Color.fromARGB(255, 255, 87, 87),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry childPadding =
        const EdgeInsets.symmetric(horizontal: 5, vertical: 15);
    return Container(
      height: 290,
      padding: childPadding,
      decoration: BoxDecoration(
        color: const Color.fromARGB(249, 243, 246, 254),
        borderRadius: BorderRadius.circular(10),
      ),
      child: FutureBuilder(
          future: getMonthCost,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Indicator();
            } else if (snapshot.hasError || snapshot.data!.isEmpty) {
              return Center(child: Text('Błąd: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nie znaleziono danych.'));
            } else {
              Map monthCost = snapshot.data!;
              return Column(
                children: [
                  Text(
                      monthCost['thisMonth']['cost'] == null
                          ? "0"
                          : currencyFormat("PLN")
                              .format(monthCost['thisMonth']['cost']),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1)),
                  const Text(
                    "KOSZTY W TYM MIESIĄCU",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  if (monthCost['monthlyAverage']['averageCost'] != 0 &&
                      monthCost['thisMonth']['cost'] != 0)
                    SizedBox(
                      height: 180,
                      child: SfRadialGauge(
                        enableLoadingAnimation: true,
                        axes: <RadialAxis>[
                          RadialAxis(
                              maximumLabels: 1,
                              minimum: 0,
                              maximum: monthCost['monthlyAverage']
                                      ['averageCost'] *
                                  2,
                              showLabels: false,
                              showTicks: false,
                              labelsPosition: ElementsPosition.outside,
                              ranges: gaugeRanges(
                                  monthCost['monthlyAverage']['averageCost']),
                              pointers: <GaugePointer>[
                                NeedlePointer(
                                  enableAnimation: true,
                                  value: monthCost['thisMonth']['cost'] == null
                                      ? 0.00
                                      : monthCost['thisMonth']['cost']
                                          .toDouble(),
                                  needleLength: 0.9,
                                  needleEndWidth: 5,
                                )
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                    widget: SizedBox(
                                      height: 100,
                                      child: Column(
                                        children: [
                                          Text(
                                              (monthCost['thisMonth']['cost'] -
                                                          monthCost[
                                                                  'monthlyAverage']
                                                              [
                                                              'averageCost']) ==
                                                      null
                                                  ? "0"
                                                  : currencyFormat("PLN").format(
                                                      (monthCost['thisMonth']
                                                                  ['cost'] -
                                                              monthCost[
                                                                      'monthlyAverage']
                                                                  [
                                                                  'averageCost'])
                                                          .abs()),
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700)),
                                          Text(
                                            (monthCost['thisMonth']['cost'] -
                                                        monthCost[
                                                                'monthlyAverage']
                                                            ['averageCost']) ==
                                                    null
                                                ? "0"
                                                : (monthCost['thisMonth']
                                                                ['cost'] -
                                                            monthCost[
                                                                    'monthlyAverage']
                                                                [
                                                                'averageCost']) >
                                                        0
                                                    ? "POWYŻEJ ŚREDNIEJ"
                                                    : "PONIŻEJ ŚREDNIEJ",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    ),
                                    angle: 90,
                                    positionFactor: 1.5)
                              ]),
                        ],
                      ),
                    ),
                ],
              );
            }
          }),
    );
  }
}
