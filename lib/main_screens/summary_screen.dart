import 'package:flutter/material.dart';
import 'package:money_tracker/general_info.dart';
import 'package:money_tracker/main_summary/balance_box.dart';
import 'package:money_tracker/main_summary/tiles_title.dart';

import '../last_documents.dart';
import '../main_summary/main_summary.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        LastDocuments(),
        BalanceBox(),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: GeneralInfo(),
        ),
        TilesTitle(),
        MainSummary(),
      ],
    );
  }
}
