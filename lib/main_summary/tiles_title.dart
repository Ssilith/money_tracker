import 'package:flutter/material.dart';
import 'package:money_tracker/last_documents.dart';
import 'package:money_tracker/main_summary/balance_box.dart';
import 'package:money_tracker/main_summary/cost_gauge.dart';
import 'package:money_tracker/main_summary/financial_result_line_chart.dart';
import 'package:money_tracker/main_summary/income_radial_bar.dart';
import 'package:money_tracker/main_summary/monthly_summary.dart';

class TilesTitle extends StatefulWidget {
  final Function updateScreen;
  const TilesTitle({super.key, required this.updateScreen});

  @override
  State<TilesTitle> createState() => _TilesTitleState();
}

class _TilesTitleState extends State<TilesTitle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Tablica",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary)),
          TextButton(
              onPressed: () => showSelectioDialog(context),
              child: const Text(
                "Dostosuj",
                style: TextStyle(color: Colors.black, fontSize: 12),
              ))
        ],
      ),
    );
  }

  showSelectioDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text(
          "Wybierz widżety",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              height: 0.5,
              color: Colors.white70),
        ),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return SizedBox(
                width: double.maxFinite,
                child: Theme(
                    data: ThemeData(
                      unselectedWidgetColor: Colors.white70,
                      canvasColor: Colors.transparent,
                    ),
                    child: ReorderableListView.builder(
                        shrinkWrap: true,
                        itemCount: widgetItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                              minLeadingWidth: 5,
                              key: ValueKey(widgetItems[index].title),
                              title: CheckboxListTile(
                                activeColor: Colors.white,
                                checkColor: Colors.blue[900],
                                value: widgetItems[index].isSelected,
                                title: Text(widgetItems[index].title,
                                    style:
                                        const TextStyle(color: Colors.white)),
                                onChanged: (bool? value) async {
                                  modalSetState(() {
                                    widgetItems[index].isSelected = value!;
                                  });
                                  widget.updateScreen();
                                  // List<String> widgetItemTitles = widgetItems
                                  //     .map((item) => item.title)
                                  //     .toList();
                                  // await UserSimplePreferences.setChosenWidgets(
                                  //     widgetItemTitles);
                                },
                              ),
                              leading: ReorderableDragStartListener(
                                key: ValueKey(widgetItems[index]),
                                index: index,
                                child: const Icon(Icons.drag_handle,
                                    color: Colors.white),
                              ));
                        },
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (newIndex > oldIndex) {
                              newIndex -= 1;
                            }
                            final item = widgetItems.removeAt(oldIndex);
                            widgetItems.insert(newIndex, item);
                          });
                          widget.updateScreen();
                        })));
          },
        ),
      ),
    );
  }
}

class WidgetItem {
  final String title;
  final Widget widget;
  bool isSelected;

  WidgetItem(
      {required this.title, required this.widget, this.isSelected = true});
}

List<WidgetItem> widgetItems = [
  WidgetItem(
    title: "Ostatnie dokumenty",
    widget: const Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: LastDocuments(),
    ),
  ),
  WidgetItem(
      title: "Bieżący budżet",
      widget: const Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
        child: BalanceBox(),
      )),
  WidgetItem(
      title: "Rozliczenie miesięczne",
      widget: const Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
        child: MonthlySummary(),
      )),
  WidgetItem(
      title: "Miesięczne koszty",
      widget: const Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
        child: CostGauge(),
      )),
  WidgetItem(
      title: "Miesięczne wpływy",
      widget: const Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
        child: IncomeRadailBar(),
      )),
  WidgetItem(
    title: "Wynik finansowy",
    widget: const Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
      child: FinancialResultLineChart(),
    ),
  ),
];
