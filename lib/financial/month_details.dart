import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_tracker/global.dart';

class MonthDetails extends StatefulWidget {
  final int selectedMonth;
  final Map monthlyData;
  const MonthDetails(
      {super.key, required this.selectedMonth, required this.monthlyData});

  @override
  State<MonthDetails> createState() => _MonthDetailsState();
}

class _MonthDetailsState extends State<MonthDetails> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: 10,
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(MdiIcons.arrowLeftCircle,
                        size: 50,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        monthNumberToNameMap[widget.selectedMonth]!,
                        style: TextStyle(
                            fontSize: 26,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 50),
                ],
              )),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04, vertical: 10),
            child: MonthDetailsSummary(
                width: size.width * 0.92, monthlyData: widget.monthlyData),
          )
        ],
      ),
    );
  }
}

class MonthDetailsSummary extends StatefulWidget {
  final double width;
  final Map monthlyData;
  const MonthDetailsSummary(
      {super.key, required this.width, required this.monthlyData});

  @override
  State<MonthDetailsSummary> createState() => _MonthDetailsSummaryState();
}

class _MonthDetailsSummaryState extends State<MonthDetailsSummary> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MonthDetailsValueTitle(
            name: "Przychody",
            value:
                currencyFormat("PLN").format(widget.monthlyData['totalIncome']),
            width: widget.width * 0.98),
        ...widget.monthlyData['incomes']
            .map((finance) => MonthDetailsValueContainer(
                  width: widget.width,
                  name: finance['categoryName'],
                  value: currencyFormat("PLN").format(finance['amount']),
                )),
        const SizedBox(height: 14),
        MonthDetailsValueTitle(
            name: "Koszty",
            value:
                currencyFormat("PLN").format(widget.monthlyData['totalCost']),
            width: widget.width * 0.98),
        ...widget.monthlyData['costs']
            .map((finance) => MonthDetailsValueContainer(
                  width: widget.width,
                  name: finance['categoryName'],
                  value: currencyFormat("PLN").format(finance['amount']),
                )),
        const SizedBox(height: 7),
        Divider(
          height: 10,
          color: Theme.of(context).colorScheme.secondary,
          thickness: 1,
        ),
        const SizedBox(height: 7),
        MonthDetailsValueTitle(
            name: (widget.monthlyData['totalIncome'] -
                        widget.monthlyData['totalCost']) >=
                    0
                ? "Zysk"
                : "Strata",
            value: currencyFormat("PLN").format(
                (widget.monthlyData['totalIncome'] -
                        widget.monthlyData['totalCost'])
                    .abs()),
            width: widget.width * 0.98),
      ],
    );
  }
}

class MonthDetailsValueTitle extends StatelessWidget {
  final String name;
  final String value;
  final double width;
  const MonthDetailsValueTitle(
      {super.key,
      required this.name,
      required this.value,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: width * 0.65,
            child: Text(name,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w500,
                    fontSize: 17))),
        SizedBox(
            width: width * 0.35,
            child: Text(value,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w500,
                    fontSize: 17))),
      ],
    );
  }
}

class MonthDetailsValueContainer extends StatelessWidget {
  final String name;
  final String value;
  final double width;
  const MonthDetailsValueContainer(
      {super.key,
      required this.width,
      required this.name,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: width * 0.01),
        child: Row(children: [
          SizedBox(width: width * 0.7, child: Text(name)),
          SizedBox(width: width * 0.25, child: Text(value)),
        ]),
      ),
    );
  }
}
