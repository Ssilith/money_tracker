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
              print(yearlysummary);
              List<QuarterValues> refactoredData = refactorData(snapshot.data!);
              return Column(
                children: [
                  YearValueBox(summary: yearlysummary['yearlySummary']),
                  for (var i in refactoredData)
                    if (i.revenue != 0.0 || i.cost != 0.0 || i.profit != 0.0)
                      QuarterBox(quarterData: i)
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
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text(
                  currencyFormat("PLN").format(summary['totalIncome']),
                  style: const TextStyle(
                      height: 1,
                      fontSize: 19,
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
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text(
                  currencyFormat("PLN").format(summary['totalCost']),
                  style: const TextStyle(
                      height: 1,
                      fontSize: 19,
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
                        fontSize: 16, fontWeight: FontWeight.w500)),
                Text(
                  currencyFormat("PLN").format(
                      (summary['totalIncome'] - summary['totalCost']).abs()),
                  style: const TextStyle(
                      height: 1,
                      fontSize: 19,
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
  const QuarterBox({super.key, required this.quarterData});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: 6),
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: size.width * 0.02, vertical: 10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(249, 243, 246, 254),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            quarterData.name,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    value: quarterData.profit,
                    color: const Color.fromARGB(255, 1, 60, 110),
                    text: "Zysk",
                    alignment: CrossAxisAlignment.end),
              ],
            ),
          ),
          Row(
            children: [
              for (var i in quarterData.months)
                if (i.revenue != 0.0 || i.cost != 0.0 || i.profit != 0.0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: MonthValueBox(monthData: i),
                  ),
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
                  fontSize: 18)),
          Text(text,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300))
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
      closedBuilder: (context, _) => Container(
        width: size.width * 0.29,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
        child: Column(
          children: [
            Text(monthData.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const Divider(
              height: 3,
              color: Colors.black26,
              thickness: 0.5,
            ),
            Text(currencyFormat("PLN").format(monthData.revenue),
                style: const TextStyle(
                    color: Color.fromARGB(255, 38, 174, 108),
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            Text(currencyFormat("PLN").format(monthData.cost),
                style: const TextStyle(
                    color: Color.fromARGB(255, 241, 81, 70),
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            Divider(height: 3, color: Theme.of(context).colorScheme.secondary),
            Text(currencyFormat("PLN").format(monthData.profit),
                style: const TextStyle(
                    color: Color.fromARGB(255, 1, 60, 110),
                    fontWeight: FontWeight.w500,
                    fontSize: 16)),
          ],
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
    String quarter = monthToQuarterMap[mData.month]!;
    quarterMonthsMap[quarter]!.add(
      MonthValues(
        monthNumberToNameMap[mData.month]!,
        mData.totalIncome,
        mData.totalCost,
        mData.totalIncome - mData.totalCost,
      ),
    );
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

final Map<int, String> monthToQuarterMap = {
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
