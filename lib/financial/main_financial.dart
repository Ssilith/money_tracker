import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/financial/month_details.dart';
import 'package:money_tracker/global.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/resources/transaction_service.dart';
import 'package:money_tracker/widgets/indicator.dart';

class MainFinancial extends StatefulWidget {
  const MainFinancial({super.key});

  @override
  State<MainFinancial> createState() => _MainFinancialState();
}

class _MainFinancialState extends State<MainFinancial> {
  Future? yearlySumm;

  @override
  void initState() {
    yearlySumm = TransactionService().getYearlySummaryAndTransactions(user.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
          future: yearlySumm,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Indicator();
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text('Wystąpił błąd. Spróbuj ponownie później.'));
            } else if (snapshot.data!.isEmpty) {
              return const Center(child: Text('Nie znaleziono transakcji.'));
            } else {
              Map yearlysummary = snapshot.data!;
              List<QuarterValues> refactoredData = refactorData(snapshot.data!);
              return Column(
                children: [
                  YearValueBox(summary: yearlysummary['yearlySummary']),
                  for (var i in refactoredData)
                    if (i.revenue != 0.0 || i.cost != 0.0 || i.profit != 0.0)
                      QuarterBox(
                        quarterData: i,
                        wholeData: yearlysummary['monthlyData'],
                      )
                ],
              );
            }
          }),
    );
  }
}

class YearValueBox extends StatelessWidget {
  final Map summary;
  const YearValueBox({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
          child: Container(
            height: 70,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(249, 243, 246, 254),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Przychody",
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                Text(
                  currencyFormat("PLN").format(summary['totalIncome']),
                  style: const TextStyle(
                      height: 1,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 38, 174, 108)),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
          child: Container(
            height: 70,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(249, 243, 246, 254),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Koszty",
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                Text(
                  currencyFormat("PLN").format(summary['totalCost']),
                  style: const TextStyle(
                      height: 1,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 241, 81, 70)),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
          child: Container(
            height: 70,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(249, 243, 246, 254),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    (summary['totalIncome'] - summary['totalCost']) >= 0
                        ? "Zysk"
                        : "Strata",
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w500)),
                Text(
                  currencyFormat("PLN").format(
                      (summary['totalIncome'] - summary['totalCost']).abs()),
                  style: const TextStyle(
                      height: 1,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 1, 60, 110)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class QuarterBox extends StatelessWidget {
  final QuarterValues quarterData;
  final List wholeData;
  const QuarterBox(
      {super.key, required this.quarterData, required this.wholeData});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 10),
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.secondary, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            iconColor: Colors.black,
            title: Text(
              quarterData.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            ),
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 2),
                  child: Column(
                    children: [
                      QuarterValueBox(
                          value: quarterData.revenue,
                          color: const Color.fromARGB(255, 38, 174, 108),
                          text: "Przychody",
                          alignment: CrossAxisAlignment.start),
                      QuarterValueBox(
                          value: quarterData.cost,
                          color: const Color.fromARGB(255, 241, 81, 70),
                          text: "Koszty",
                          alignment: CrossAxisAlignment.center),
                      QuarterValueBox(
                          value: quarterData.profit.abs(),
                          color: const Color.fromARGB(255, 1, 60, 110),
                          text: quarterData.profit >= 0 ? "Zysk" : "Strata",
                          alignment: CrossAxisAlignment.end),
                    ],
                  ),
                ),
                Column(
                  children: [
                    for (var i in quarterData.months)
                      MonthValueBox(
                        monthData: i,
                        wholeData: wholeData,
                      ),
                  ],
                )
              ]),
            ],
          ),
        ),
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
      width: size.width * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            Text(currencyFormat("PLN").format(value),
                style: TextStyle(
                    height: 0.8,
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 18))
          ],
        ),
      ),
    );
  }
}

class MonthValueBox extends StatelessWidget {
  final MonthValues monthData;
  final List wholeData;
  const MonthValueBox(
      {super.key, required this.monthData, required this.wholeData});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return OpenContainer(
      closedBuilder: (context, _) => Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.005),
        child: Container(
          width: size.width * 0.9,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(monthData.name,
                    style: const TextStyle(
                        fontSize: 21, fontWeight: FontWeight.w500)),
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.info,
                    color: Colors.black,
                    size: 20.0,
                  ),
                )
              ]),
              const Divider(
                height: 10,
                color: Colors.black26,
                thickness: 0.5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Przychody",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w300)),
                      Text(currencyFormat("PLN").format(monthData.revenue),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 38, 174, 108),
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Koszty",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w300)),
                      Text(currencyFormat("PLN").format(monthData.cost),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 241, 81, 70),
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ],
                  ),
                  const Divider(height: 3, color: Colors.black),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(monthData.profit >= 0 ? "Zysk" : "Strata",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      Text(currencyFormat("PLN").format(monthData.profit.abs()),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 1, 60, 110),
                              fontWeight: FontWeight.w600,
                              fontSize: 18)),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
      openBuilder: (context, _) => MonthDetails(
        selectedMonth: monthData.number,
        monthlyData: wholeData.firstWhere(
            (data) => data['month'] == monthData.number,
            orElse: () => null),
      ),
      transitionType: ContainerTransitionType.fadeThrough,
      transitionDuration: const Duration(milliseconds: 1200),
    );
  }
}

class MonthValues {
  MonthValues(this.name, this.revenue, this.cost, this.profit, this.number);
  final String name;
  final int number;
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

class MonthlyData {
  final int month;
  final List<Map<String, dynamic>> costs;
  final double totalCost;
  final List<Map<String, dynamic>> incomes;
  final double totalIncome;

  MonthlyData({
    required this.month,
    required this.costs,
    required this.totalCost,
    required this.incomes,
    required this.totalIncome,
  });
}

List<QuarterValues> refactorData(Map<String, dynamic> yearlySummary) {
  List<Map<String, dynamic>> monthlyDataList =
      List<Map<String, dynamic>>.from(yearlySummary['monthlyData']);

  List<MonthlyData> monthlyDataObjects = monthlyDataList
      .map((data) => MonthlyData(
          month: data['month'],
          costs: List<Map<String, dynamic>>.from(data['costs']),
          totalCost: data['totalCost'] + 0.0,
          incomes: List<Map<String, dynamic>>.from(data['incomes']),
          totalIncome: data['totalIncome'] + 0.0))
      .toList();

  Map<String, List<MonthValues>> quarterMonthsMap = {
    "Kwartał 1": [],
    "Kwartał 2": [],
    "Kwartał 3": [],
    "Kwartał 4": []
  };

  for (MonthlyData mData in monthlyDataObjects) {
    if (mData.totalIncome != 0.0 || mData.totalCost != 0.0) {
      String quarter = monthToQuarterMap[mData.month]!;
      quarterMonthsMap[quarter]!.add(
        MonthValues(
          monthNumberToNameMap[mData.month]!,
          mData.totalIncome,
          mData.totalCost,
          mData.totalIncome - mData.totalCost,
          mData.month,
        ),
      );
    }
  }

  List<QuarterValues> quarters = [];
  quarterMonthsMap.forEach((quarter, months) {
    if (months.isNotEmpty) {
      double quarterRevenue = months.fold(0.0, (prev, m) => prev + m.revenue);
      double quarterCost = months.fold(0.0, (prev, m) => prev + m.cost);
      double quarterProfit = months.fold(0.0, (prev, m) => prev + m.profit);

      quarters.add(QuarterValues(
          months, quarter, quarterRevenue, quarterCost, quarterProfit));
    }
  });

  return quarters;
}

Map<int, String> monthToQuarterMap = {
  1: "Kwartał 1",
  2: "Kwartał 1",
  3: "Kwartał 1",
  4: "Kwartał 2",
  5: "Kwartał 2",
  6: "Kwartał 2",
  7: "Kwartał 3",
  8: "Kwartał 3",
  9: "Kwartał 3",
  10: "Kwartał 4",
  11: "Kwartał 4",
  12: "Kwartał 4"
};
