import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:money_tracker/main_summary/tiles_title.dart';
import 'package:money_tracker/resources/user_simple_preferences.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        TilesTitle(
          updateScreen: () {
            setState(() {});
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
          child: StaggeredGrid.count(
            crossAxisCount: 1,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: getOrderedWidgets(),
          ),
        ),
      ],
    );
  }
}

List<Widget> getOrderedWidgets() {
  List<String>? savedWidgets = UserSimplePreferences.getChosenWidgets();
  if (savedWidgets == null || savedWidgets.isEmpty) {
    return widgetItems.where((e) => e.isSelected).map((e) => e.widget).toList();
  }

  List<Widget> orderedWidgets = [];

  for (var title in savedWidgets) {
    final item = widgetItems.firstWhere((item) => item.title == title);
    orderedWidgets.add(item.widget);
  }

  return orderedWidgets;
}
