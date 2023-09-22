import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../global.dart';

class PieChartBox extends StatefulWidget {
  final List categories;

  const PieChartBox({Key? key, required this.categories}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartBoxState();
}

class PieChartBoxState extends State<PieChartBox> {
  int touchedIndex = -1;
  bool showPercentage = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent touchEvent,
                      PieTouchResponse? pieTouchResponse) {
                    if (pieTouchResponse != null) {
                      setState(() {
                        if (touchEvent is FlLongPressEnd ||
                            touchEvent is FlPanEndEvent) {
                          touchedIndex = -1;
                        } else {
                          if (touchedIndex ==
                              pieTouchResponse
                                  .touchedSection?.touchedSectionIndex) {
                            showPercentage = !showPercentage;
                          } else {
                            showPercentage = false;
                          }
                          touchedIndex = pieTouchResponse
                                  .touchedSection?.touchedSectionIndex ??
                              -1;
                        }
                      });
                    }
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: showingSections(widget.categories),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildIndicators(widget.categories),
        ),
        const SizedBox(width: 30),
      ],
    );
  }

  List<PieChartSectionData> showingSections(List categories) {
    return List.generate(categories.length, (i) {
      final double expense = double.parse(categories[i]['expense'].toString());
      final double percentage =
          double.parse(categories[i]['percentage'].toString());
      final bool isTouched = i == touchedIndex;
      final String title = isTouched
          ? (showPercentage
              ? '$percentage%'
              : currencyFormat('PLN').format(expense))
          : currencyFormat('PLN').format(expense);
      return PieChartSectionData(
        color: Color(int.parse(categories[i]['color'].toString())),
        value: percentage,
        title: title,
        showTitle: percentage < 5 ? false : true,
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    });
  }

  List<Widget> _buildIndicators(List categories) {
    List<Widget> widgets = [];
    for (var category in categories) {
      widgets.add(MyIndicator(
        color: Color(int.parse(category['color'])),
        text: category['category'],
        textColor: Colors.white,
      ));
    }
    return widgets;
  }
}

class MyIndicator extends StatelessWidget {
  const MyIndicator({
    super.key,
    required this.color,
    required this.text,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: textColor,
          ),
        )
      ],
    );
  }
}
