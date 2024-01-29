import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tokyu_envy_report/components/report/legend_widget.dart';
import 'package:tokyu_envy_report/etc/define.dart';
import 'package:tokyu_envy_report/etc/style.dart';
import 'package:tokyu_envy_report/state/state_model.dart';

Map<int, int> _generate(List answers) {
  final Map<int, int> map = {};
  answers.asMap().forEach((key, value) {
    if (value < 0) return;
    if (map.isEmpty || key == 0) {
      map[value] = 1;
    } else {
      if (map[value] != null) {
        map.update(value, (existingValue) => existingValue + 1);
      } else {
        map[value] = 1;
      }
    }
  });

  if (map.length == answers2.length) return map;
  List.generate(answers2.length, (i) {
    if (map[i] == null) {
      map[i] = 0;
    }
  });
  return map;
}

class SurveyQuestionPieChart extends StatelessWidget {
  final List<Visitor> visitors;
  final String title;
  final int questionIndex;
  final double width;
  const SurveyQuestionPieChart(
      {super.key, required this.visitors, required this.title, required this.questionIndex, required this.width});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = Style.of(context);

    const emptyAnswer = [-1, -1, -1, -1];
    final answers = visitors.map((e) => e.afterAnswers.isNotEmpty ? e.afterAnswers : emptyAnswer).toList();
    final indexedAnswers = answers.map((e) => e[questionIndex]).toList();
    final map = _generate(indexedAnswers);
    final keys = map.keys.toList()..sort();
    final Map<int, int> sortedMap = Map.fromEntries(keys.map((key) => MapEntry(key, map[key] ?? 0)));
    final radius = width > 480 ? 65.00 : (width - 100) / 4;

    return Container(
      width: width - 50,
      margin: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          border: Border.all(width: 2.0, color: theme.colorScheme.outline), borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center, //y
        crossAxisAlignment: CrossAxisAlignment.center, //x
        children: [
          const SizedBox(height: 10),
          Text(title, style: style.graphMediumTitle),
          const SizedBox(height: 10),
          Container(
            width: width - 100,
            height: 150,
            color: theme.cardColor.withOpacity(0.7),
            child: PieChart(PieChartData(
              sectionsSpace: 2,
              borderData:
                  FlBorderData(show: true, border: Border.all(width: 2.0, color: Colors.white.withOpacity(0.4))),
              centerSpaceRadius: 0,
              sections: List.generate(sortedMap.length, (i) {
                final value = sortedMap[i] ?? 0;
                double percentValue = value * (100 / visitors.length);
                String percentString = percentValue.toStringAsFixed(1);

                return PieChartSectionData(
                  color: answers2Colors[i],
                  value: double.parse(percentString),
                  title: '$percentString%',
                  radius: radius,
                  titleStyle: style.pieChartTitleText,
                );
              }),
            )),
          ),
          const SizedBox(height: 14),
          LegendsListWidget(
              legends: map.keys.map((key) {
            return Legend(answers2[key], answers2Colors[key]);
          }).toList()),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}
