import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tokyu_envy_report/components/survey/property_table.dart';
import 'package:tokyu_envy_report/etc/style.dart';
import 'package:tokyu_envy_report/state/state_visitor.dart';

Map<String, int> _generateMap(WidgetRef ref) {
  final Map<String, int> map = {};

  List.filled(12, 1).asMap().forEach((key, value) {
    final values = ref.watch(visitorHistory(DateTime(DateTime.now().year - 1, key + 1).toIso8601String()));
    for (var value in values) {
      if (value.property.isEmpty) continue;
      if (map[value.property] != null) {
        map.update(value.property, (existingValue) => existingValue + 1);
      } else {
        map[value.property] = 1;
      }
    }
  });

  return map;
}

List<BarChartGroupData> _generateBarGroups(
    {required Map<String, int> map, required double width, required ThemeData theme}) {
  final List<BarChartGroupData> barGroups = [];
  final setWidth = width > 1000 ? (width / 50) - 5 : width / 50;

  final values = map.values.toList();
  values.asMap().forEach((index, value) {
    final percentValue = values[index] * (100 / values.length);
    final percentString = percentValue.toStringAsFixed(0);
    final percentInt = int.parse(percentString);

    barGroups.add(BarChartGroupData(x: index, barsSpace: width / 50, barRods: [
      BarChartRodData(
          toY: percentInt.toDouble(), borderRadius: BorderRadius.zero, width: setWidth, color: Colors.greenAccent)
    ]));
  });

  return barGroups;
}

class VisitorByProperty extends ConsumerWidget {
  const VisitorByProperty({super.key = const Key('s_visitor_by_property')});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = Style.of(context);
    final mq = MediaQuery.of(context);
    final width = mq.size.width;

    final map = _generateMap(ref);
    final properties = map.keys.toList();
    final intervalDouble = map.length / 4;
    final intervalStr = intervalDouble.toStringAsFixed(0);
    final interval = int.parse(intervalStr);

    return Column(children: [
      Text('来場目的（物件名）', style: style.graphMediumTitle),
      const SizedBox(height: 10),
      PropertiesTable(properties: properties),
      const SizedBox(height: 10),
      Text(
        '来場目的 (人数の割合 vs. 物件名)',
        style: style.graphMainTitle,
      ),
      Container(
        width: width > 480 ? (width / 2) - 100 : width - 50,
        height: width > 480 ? (width / 3) - 100 : 200,
        padding: const EdgeInsets.all(15.0),
        child: Container(
          width: 300,
          height: 150,
          color: theme.cardColor.withOpacity(0.7),
          child: BarChart(BarChartData(
              alignment: BarChartAlignment.center,
              barTouchData: BarTouchData(enabled: false),
              borderData:
                  FlBorderData(show: true, border: Border.all(width: 2.0, color: Colors.white.withOpacity(0.4))),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                drawHorizontalLine: true,
                horizontalInterval: interval.toDouble(),
                checkToShowHorizontalLine: (value) => value % 2 == 0,
              ),
              titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final pName = value.toInt();
                      final title = '物件${pName + 1}';

                      return SideTitleWidget(
                          axisSide: meta.axisSide, angle: 45, child: Text(title, style: style.graphTitles));
                    },
                  )),
                  leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                    showTitles: true,
                    interval: interval.toDouble(),
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                          axisSide: meta.axisSide, child: Text(meta.formattedValue, style: style.graphTitles));
                    },
                  ))),
              barGroups: _generateBarGroups(map: map, width: width, theme: theme))),
        ),
      ),
      const SizedBox(height: 10),
    ]);
  }
}
