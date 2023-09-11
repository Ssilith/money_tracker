import 'package:flutter/material.dart';
import 'package:money_tracker/widgets/main_box.dart';

class FinancialResultTable extends StatefulWidget {
  const FinancialResultTable({super.key});

  @override
  State<FinancialResultTable> createState() => _FinancialResultTableState();
}

class _FinancialResultTableState extends State<FinancialResultTable> {
  @override
  Widget build(BuildContext context) {
    return const MainBox(
      child: Column(
        children: [
          WarningRow(message: "Nietypowy wydatek"),
          Text("EMD International",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
          Text("27 020,01 €",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.red)),
          Text(
            "Kurs obsługi programu komputerowego",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          Divider(),
          WarningRow(message: "Wydatki wyższe niż zwykle"),
          Text("Podróże służbowe",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
          Text("21 897,23 zł",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.red)),
          Text(
            "31% więcej niż średnia z ostatniego roku",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class WarningRow extends StatelessWidget {
  final String message;
  const WarningRow({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.warning_rounded,
          size: 20,
          color: Theme.of(context).colorScheme.secondary,
        ),
        Text(
          message,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
