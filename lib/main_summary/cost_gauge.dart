import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CostGauge extends StatefulWidget {
  const CostGauge({super.key});

  @override
  State<CostGauge> createState() => _CostGaugeState();
}

class _CostGaugeState extends State<CostGauge> {
  double gaugeWidth = 60;
  double average = 147890.52;

  List<GaugeRange> gaugeRanges() {
    return [
      GaugeRange(
        startWidth: gaugeWidth,
        endWidth: gaugeWidth,
        startValue: 0,
        endValue: 0.4 * average,
        color: Colors.green,
      ),
      GaugeRange(
        startWidth: gaugeWidth,
        endWidth: gaugeWidth,
        startValue: 0.4 * average,
        endValue: 0.8 * average,
        color: Colors.lightGreen,
      ),
      GaugeRange(
        startWidth: gaugeWidth,
        endWidth: gaugeWidth,
        startValue: 0.8 * average,
        endValue: 1.2 * average,
        color: Colors.yellow,
      ),
      GaugeRange(
        startWidth: gaugeWidth,
        endWidth: gaugeWidth,
        startValue: 1.2 * average,
        endValue: 1.6 * average,
        color: Colors.orange,
      ),
      GaugeRange(
        startWidth: gaugeWidth,
        endWidth: gaugeWidth,
        startValue: 1.6 * average,
        endValue: 2 * average,
        color: Colors.red,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry childPadding = kIsWeb
        ? const EdgeInsets.fromLTRB(24, 18, 24, 6)
        : const EdgeInsets.fromLTRB(5, 5, 5, 5);
    return Container(
      padding: childPadding,
      child: Column(
        children: [
          const Text('240 123,12 zł',
              style: TextStyle(
                  fontSize: kIsWeb ? 24 : 15,
                  fontWeight: FontWeight.w700,
                  height: 1)),
          const Text(
            "KOSZTY W TYM MIESIĄCU",
            style: TextStyle(
                fontSize: kIsWeb ? 13 : 10, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 180,
            // width: 300,
            child: SfRadialGauge(
              enableLoadingAnimation: true,
              axes: <RadialAxis>[
                RadialAxis(
                    maximumLabels: 1,
                    minimum: 0,
                    maximum: average * 2,
                    showLabels: false,
                    showTicks: false,
                    labelsPosition: ElementsPosition.outside,
                    // ticksPosition: ElementsPosition.outside,
                    ranges: gaugeRanges(),
                    pointers: const <GaugePointer>[
                      NeedlePointer(
                        enableAnimation: true,
                        value: 180123.12,
                        needleLength: 0.9,
                        needleEndWidth: 5,
                      )
                    ],
                    annotations: const <GaugeAnnotation>[
                      GaugeAnnotation(
                          widget: SizedBox(
                            height: 50,
                            child: Column(
                              children: [
                                Text('49 752,90 zł',
                                    style: TextStyle(
                                        fontSize: kIsWeb ? 16 : 14,
                                        fontWeight: FontWeight.w800)),
                                Text(
                                  "powyżej średniej",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                          angle: 90,
                          positionFactor: 0.9)
                    ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
