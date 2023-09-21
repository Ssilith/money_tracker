import 'package:flutter/material.dart';
import 'package:money_tracker/main_summary/balance_box.dart';
import 'package:money_tracker/main_summary/budget_widget.dart';
import 'package:money_tracker/main_summary/tiles_title.dart';
import 'package:money_tracker/resources/user_service.dart';
import 'package:money_tracker/widgets/indicator.dart';
import '../last_documents.dart';
import '../main_summary/main_summary.dart';

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
        LastDocuments(),
        SizedBox(height: 5),
        BudgetWidget(),
        // SizedBox(height: 5),
        BalanceBox(),
        SizedBox(height: 5),
        MainSummary(),
      ],
    );
  }
}
