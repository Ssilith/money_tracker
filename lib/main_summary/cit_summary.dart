import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../global.dart';

class CitSummary extends StatefulWidget {
  const CitSummary({super.key});

  @override
  State<CitSummary> createState() => _CitSummaryState();
}

class _CitSummaryState extends State<CitSummary> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: transparentOnGradient(),
        width: 300,
        height: 160,
        child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Rozliczenie CIT",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: kIsWeb ? 22 : 14),
              ),
              // SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "12 555 zł",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: kIsWeb ? 20 : 16),
                  ),
                  Text(
                    "POPRZEDNI MIESIĄC",
                    style: TextStyle(
                        fontSize: kIsWeb ? 12 : 8, fontWeight: FontWeight.w500),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "37 825 zł",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: kIsWeb ? 20 : 16),
                  ),
                  Text(
                    "TEN ROK",
                    style: TextStyle(
                        fontSize: kIsWeb ? 12 : 8, fontWeight: FontWeight.w500),
                  )
                ],
              ),
              SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "4 589 zł",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 1,
                        fontSize: kIsWeb ? 20 : 16,
                        color: Colors.red),
                  ),
                  Text(
                    "PRZEWIDYWANY DEBET",
                    style: TextStyle(
                        fontSize: kIsWeb ? 12 : 9, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ]));
  }
}
