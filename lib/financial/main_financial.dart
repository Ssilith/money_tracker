import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_tracker/financial/month_details.dart';
import 'package:money_tracker/global.dart';

class MainFinancial extends StatefulWidget {
  const MainFinancial({super.key});

  @override
  State<MainFinancial> createState() => _MainFinancialState();
}

class _MainFinancialState extends State<MainFinancial> {
  final List<QuarterValues> yearExample = [
    QuarterValues([
      MonthValues("Styczeń", 201951, 98359, 103591),
      MonthValues("Luty", 152465, 72596, 79869),
      MonthValues("Marzec", 153535, 67875, 85661),
    ], "Kwartał 1", 507951, 238830, 269121),
    QuarterValues([
      MonthValues("Kwiecień", 155712, 80661, 75052),
      MonthValues("Maj", 148857, 56805, 92052),
    ], "Kwartał 2", 304569, 137466, 167104),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Opacity(
          opacity: 0.6,
          child: Image(
            image: AssetImage("assets/doc_1.png"),
            width: 300,
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              const Row(
                children: [
                  Image(
                    image: AssetImage("assets/logo.png"),
                    width: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("2023",
                          style: TextStyle(
                              height: 1,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      Text(
                          "Sprawozdanie za ten rok nie zostało jeszcze zatwierdzone",
                          style: TextStyle(
                              fontSize: 10,
                              height: 1,
                              fontWeight: FontWeight.w300))
                    ],
                  ),
                ],
              ),
              const YearValueBox(),
              for (var i in yearExample) QuarterBox(quarterData: i)
            ],
          ),
        ),
      ],
    );
  }
}

class YearValueBox extends StatelessWidget {
  const YearValueBox({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.white70, borderRadius: BorderRadius.circular(10)),
          width: size.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "812 520,00 zł",
                    style: TextStyle(
                        height: 1,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  Text("Przychody",
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.w300))
                ],
              ),
              Row(
                children: [
                  Icon(MdiIcons.arrowUpCircle, color: Colors.green),
                  const SizedBox(
                    width: 100,
                    child: Text("14% więcej niż w zeszłym roku",
                        style: TextStyle(fontSize: 11, height: 1)),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.white70, borderRadius: BorderRadius.circular(10)),
          width: size.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "376 296,00 zł",
                    style: TextStyle(
                        height: 1,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  Text("Koszty",
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.w300))
                ],
              ),
              Row(
                children: [
                  Icon(MdiIcons.arrowUpCircle, color: Colors.red),
                  const SizedBox(
                    width: 100,
                    child: Text("5% więcej niż w zeszłym roku",
                        style: TextStyle(fontSize: 11, height: 1)),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.white70, borderRadius: BorderRadius.circular(10)),
          width: size.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "436 224,00 zł",
                    style: TextStyle(
                        height: 1,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  const Text("Zysk brutto",
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.w300))
                ],
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Zapłacone podatki: ",
                    style: TextStyle(fontSize: 10),
                  ),
                  TaxBox(value: "86 790 zł", name: "VAT"),
                  TaxBox(value: "41 568 zł", name: "CIT")
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class TaxBox extends StatelessWidget {
  final String value;
  final String name;
  const TaxBox({super.key, required this.value, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(width: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(20)),
          child: Text(name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 12)),
        )
      ],
    );
  }
}

class QuarterBox extends StatelessWidget {
  final QuarterValues quarterData;
  const QuarterBox({super.key, required this.quarterData});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: 6),
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: size.width * 0.02, vertical: 10),
        decoration: withShadow(),
        // width: size.width * 0.9,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            quarterData.name,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                QuarterValueBox(
                    value: quarterData.revenue,
                    color: Colors.green,
                    text: "Przychody",
                    alignment: CrossAxisAlignment.start),
                QuarterValueBox(
                    value: quarterData.cost,
                    color: Colors.red,
                    text: "Koszty",
                    alignment: CrossAxisAlignment.center),
                QuarterValueBox(
                    value: quarterData.profit,
                    color: Theme.of(context).colorScheme.secondary,
                    text: "Zysk",
                    alignment: CrossAxisAlignment.end),
              ],
            ),
          ),
          Row(
            children: [
              for (var i in quarterData.months) MonthValueBox(monthData: i),
            ],
          )
        ]),
      ),
    );
  }
}

class QuarterValueBox extends StatelessWidget {
  final double value;
  final Color color;
  final String text;
  final CrossAxisAlignment alignment;
  const QuarterValueBox(
      {super.key,
      required this.value,
      required this.color,
      required this.text,
      required this.alignment});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.3,
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Text(currencyFormat("PLN").format(value),
              style: TextStyle(
                  height: 0.8,
                  color: color,
                  fontWeight: FontWeight.w500,
                  fontSize: 16)),
          Text(text,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w300))
        ],
      ),
    );
  }
}

class MonthValueBox extends StatelessWidget {
  final MonthValues monthData;
  const MonthValueBox({super.key, required this.monthData});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return OpenContainer(
      closedBuilder: (context, _) => Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.005),
        child: Container(
          decoration: withShadow(),
          width: size.width * 0.29,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
          child: Column(
            children: [
              Text(monthData.name,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w500)),
              const Divider(
                height: 3,
                color: Colors.black26,
                thickness: 0.5,
              ),
              Text(currencyFormat("PLN").format(monthData.revenue),
                  style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
              Text(currencyFormat("PLN").format(monthData.cost),
                  style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
              Divider(
                  height: 3, color: Theme.of(context).colorScheme.secondary),
              Text(currencyFormat("PLN").format(monthData.profit),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 12)),
            ],
          ),
        ),
      ),
      openBuilder: (context, _) => const MonthDetails(),
      transitionType: ContainerTransitionType.fadeThrough,
      transitionDuration: const Duration(milliseconds: 1200),
    );
  }
}

class MonthValues {
  MonthValues(this.name, this.revenue, this.cost, this.profit);
  final String name;
  final double revenue;
  final double cost;
  final double profit;
}

class QuarterValues {
  QuarterValues(this.months, this.name, this.revenue, this.cost, this.profit);
  final List<MonthValues> months;
  final String name;
  final double revenue;
  final double cost;
  final double profit;
}
