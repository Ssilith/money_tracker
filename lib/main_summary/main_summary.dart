import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:money_tracker/main_summary/cost_gauge.dart';
import 'package:money_tracker/main_summary/financial_result_line_chart.dart';
import 'package:money_tracker/main_summary/vat_summary.dart';

class MainSummary extends StatefulWidget {
  const MainSummary({super.key});

  @override
  State<MainSummary> createState() => _MainSummaryState();
}

class _MainSummaryState extends State<MainSummary> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (kIsWeb)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Szybkie podsumowanie",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        // const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
          child: StaggeredGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: const [
              StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1.2,
                  child: CostGauge()),
              StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 0.9,
                  child: VatSummary()),
              StaggeredGridTile.count(
                  crossAxisCellCount: 2,
                  mainAxisCellCount: 2,
                  child: FinancialResultLineChart()),
            ],
          ),
        ),
      ],
    );
  }
}
