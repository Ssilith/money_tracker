import 'package:flutter/material.dart';
import 'package:money_tracker/main_summary/balance_box.dart';
import 'package:money_tracker/main_summary/financial_result_line_chart.dart';
import 'package:money_tracker/main_summary/monthly_summary.dart';
import 'package:money_tracker/main_summary/tiles_title.dart';
import 'package:money_tracker/resources/user_service.dart';
import 'package:money_tracker/widgets/indicator.dart';
import '../last_documents.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future _initializeData() async {
    await UserService().getUserData();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Indicator();
    }
    return ListView(
      padding: EdgeInsets.zero,
      children: const [
        TilesTitle(),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: LastDocuments(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
          child: BalanceBox(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
          child: MonthlySummary(),
        ),
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
        //   child: CostGauge(),
        // ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
          child: FinancialResultLineChart(),
        ),
      ],
    );
  }
}
