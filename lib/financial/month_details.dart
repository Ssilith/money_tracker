import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MonthDetails extends StatefulWidget {
  const MonthDetails({super.key});

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(MdiIcons.arrowLeftCircle,
                      size: 50, color: Theme.of(context).colorScheme.secondary),
                ),
              ],
            ),
          ),
          Text("Styczeń 2023",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 26,
                  color: Theme.of(context).colorScheme.secondary)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: MonthDetailsSummary(width: size.width * 0.92),
          )
        ],
      ),
    );
  }
}

class MonthDetailsSummary extends StatefulWidget {
  final double width;
  const MonthDetailsSummary({super.key, required this.width});

  @override
  State<MonthDetailsSummary> createState() => _MonthDetailsSummaryState();
}

class _MonthDetailsSummaryState extends State<MonthDetailsSummary> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MonthDetailsValueTitle(
            name: "Przychody", value: "123 650 zł", width: widget.width),
        MonthDetailsValueContainer(
          width: widget.width,
          name: "ze sprzedaży",
          value: "60 782 zł",
          growth: -3,
        ),
        MonthDetailsValueContainer(
          width: widget.width,
          name: "finansowe",
          value: "13 874 zł",
          growth: 19,
        ),
        MonthDetailsValueContainer(
          width: widget.width,
          name: "inne",
          value: "20 098 zł",
          growth: 70,
        ),
        const SizedBox(height: 14),
        MonthDetailsValueTitle(
            name: "Koszty", value: "98 067 zł", width: widget.width),
        MonthDetailsValueContainer(
          width: widget.width,
          name: "ze sprzedaży",
          value: "60 782 zł",
          growth: -3,
        ),
        MonthDetailsValueContainer(
          width: widget.width,
          name: "finansowe",
          value: "13 874 zł",
          growth: 19,
        ),
        MonthDetailsValueContainer(
          width: widget.width,
          name: "inne",
          value: "20 098 zł",
          growth: 70,
        ),
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
            width: width * 0.56,
            child: Text(name,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w500))),
        SizedBox(
            width: width * 0.44,
            child: Text(value,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w500))),
      ],
    );
  }
}

class MonthDetailsValueContainer extends StatelessWidget {
  final String name;
  final String value;
  final int growth;
  final double width;
  const MonthDetailsValueContainer(
      {super.key,
      required this.width,
      required this.name,
      required this.value,
      required this.growth});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: width * 0.01),
        // decoration: withShadow(),
        child: Row(children: [
          SizedBox(width: width * 0.56, child: Text(name)),
          SizedBox(width: width * 0.28, child: Text(value)),
          SizedBox(
              width: width * 0.14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                      growth > 0
                          ? MdiIcons.arrowUpCircle
                          : MdiIcons.arrowDownCircle,
                      size: 15,
                      color: growth > 0 ? Colors.green : Colors.red),
                  Text("${growth.toString()}%",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: growth > 0 ? Colors.green : Colors.red)),
                ],
              )),
        ]),
      ),
    );
  }
}
