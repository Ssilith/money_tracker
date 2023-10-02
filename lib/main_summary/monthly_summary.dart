import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:money_tracker/global.dart';

class MonthlySummary extends StatefulWidget {
  const MonthlySummary({super.key});

  @override
  State<MonthlySummary> createState() => _MonthlySummaryState();
}

class _MonthlySummaryState extends State<MonthlySummary> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: transparentOnGradient(),
      width: 300,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Rozliczenie miesięczne",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: kIsWeb ? 22 : 14),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "32 141 zł",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: kIsWeb ? 20 : 14),
              ),
              Text(
                "KOSZTY",
                style: TextStyle(
                    fontSize: kIsWeb ? 12 : 10, fontWeight: FontWeight.bold),
              )
            ],
          ),
          SfLinearGauge(
            showLabels: false,
            showTicks: false,
            minimum: 0,
            maximum: 42312,
            barPointers: const [
              LinearBarPointer(
                edgeStyle: LinearEdgeStyle.bothCurve,
                thickness: 10,
                value: 32141,
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "43 312 zł",
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: kIsWeb ? 20 : 14),
              ),
              Text(
                "PRZYCHODY",
                style: TextStyle(
                    fontSize: kIsWeb ? 12 : 10, fontWeight: FontWeight.bold),
              )
            ],
          ),
          SfLinearGauge(
            showLabels: false,
            showTicks: false,
            minimum: 0,
            maximum: 42312,
            barPointers: const [
              LinearBarPointer(
                edgeStyle: LinearEdgeStyle.bothCurve,
                thickness: 10,
                value: 42312,
                color: Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "11 171 zł",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: kIsWeb ? 20 : 18),
              ),
              Text(
                "ZYSK",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }
}
