import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tokyu_envy_report/components/survey/property_table.dart';
import 'package:tokyu_envy_report/etc/style.dart';
import 'package:tokyu_envy_report/state/state_visitor.dart';

Map<String, int> _generateMap(WidgetRef ref, DateTime datetime) {
  final Map<String, int> map = {};
  final List<String> id = [];

  final values = ref.read(visitorHistory(datetime.toIso8601String()));

  values.asMap().forEach((key, value) {
    if (value.property.isEmpty) return;
    if (key == 0 || id.isEmpty) {
      id.add(value.id);
      map[value.property] = 1;
    } else {
      if (id.contains(value.id)) return;
      id.add(value.id);

      if (map[value.property] != null) {
        map.update(value.property, (existingValue) => existingValue + 1);
      } else {
        map[value.property] = 1;
      }
    }
  });

  return map;
}

List<BarChartGroupData> _generateBarGroups({required Map<String, int> map, required double width}) {
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

final _dateTime = StateProvider.autoDispose((ref) => DateTime.now().copyWith(
      month: DateTime.now().month - 1,
      day: 1,
      hour: 0,
      minute: 0,
      millisecond: 0,
      microsecond: 0,
    ));

class VisitorByProperty extends ConsumerWidget {
  const VisitorByProperty({super.key = const Key('s_visitor_by_property')});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = Style.of(context);
    final mq = MediaQuery.of(context);
    final width = mq.size.width;

    final datetime = ref.watch(_dateTime);
    final map = _generateMap(ref, datetime);
    final properties = map.keys.toList();

    return Column(children: [
      Text(
        '来場目的 (人数の割合 vs. 物件名)',
        style: style.graphMainTitle,
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                ref.read(_dateTime.notifier).update((state) => state.copyWith(month: state.month - 1));
              },
              icon: const Icon(Icons.arrow_back_ios, size: 15)),
          TextButton(
              onPressed: () {},
              child: Text(
                DateFormat('yyyy-MM').format(datetime),
                style: theme.textTheme.titleLarge,
              )),
          IconButton(
              onPressed: () {
                ref.read(_dateTime.notifier).update((state) => state.copyWith(month: state.month + 1));
              },
              icon: const Icon(Icons.arrow_forward_ios, size: 15)),
        ],
      ),
      const SizedBox(height: 8),
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
              gridData: const FlGridData(
                show: true,
                drawVerticalLine: false,
                drawHorizontalLine: true,
                horizontalInterval: 30,
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
                    interval: 30,
                    getTitlesWidget: (value, meta) {
                      final title = meta.formattedValue == '100' ? '' : meta.formattedValue;
                      return SideTitleWidget(axisSide: meta.axisSide, child: Text(title, style: style.graphTitles));
                    },
                  ))),
              barGroups: _generateBarGroups(map: map, width: width))),
        ),
      ),
      PropertiesTable(properties: properties),
      const SizedBox(height: 10),
    ]);
  }
}
