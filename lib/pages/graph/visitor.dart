import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tokyu_envy_report/components/report/legend_widget.dart';
import 'package:tokyu_envy_report/etc/style.dart';
import 'package:tokyu_envy_report/l10n/l10n.dart';
import 'package:tokyu_envy_report/state/state_visitor.dart';

List<BarChartGroupData> _generate(WidgetRef ref, double width) {
  final List<BarChartGroupData> barGroups = [];
  final setWidth = width > 1000 ? (width / 50) - 5 : width / 50;

  List.filled(12, 1).asMap().forEach((key, value) {
    final visitors = ref.watch(visitorHistory(DateTime(DateTime.now().year - 1, key + 1).toIso8601String()));
    final firstTimers = visitors.where((element) => element.isFirstTime).toList();
    final nonFirstTimers = visitors.where((element) => !element.isFirstTime).toList();
    barGroups.add(BarChartGroupData(x: key + 1, barsSpace: width / 50, barRods: [
      BarChartRodData(
          toY: visitors.length.toDouble(),
          borderRadius: BorderRadius.zero,
          width: setWidth,
          rodStackItems: [
            BarChartRodStackItem(0, firstTimers.length.toDouble(), Colors.greenAccent),
            BarChartRodStackItem(firstTimers.length.toDouble(), (nonFirstTimers.length + firstTimers.length).toDouble(),
                const Color(0xFF484039))
          ])
    ]));
  });
  return barGroups;
}

class VisitorByMonth extends ConsumerWidget {
  const VisitorByMonth({super.key = const Key('s_visitor_by_month')});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final theme = Theme.of(context);
    final style = Style.of(context);
    final mq = MediaQuery.of(context);
    final width = mq.size.width;

    Widget bottomTitles(double value, TitleMeta meta) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text('$value月', style: style.graphTitles),
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            l10n.monthly_visitors.replaceAll('@', (DateTime.now().year - 1).toString()),
            style: style.graphMainTitle,
          ),
          const SizedBox(height: 8),
          LegendsListWidget(
            legends: [
              Legend(l10n.first_time_visitors, Colors.greenAccent),
              Legend(l10n.non_first_time_visitors, const Color(0xFF484039)),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: width > 480 ? (width / 2) - 100 : width - 50,
            height: width > 480 ? (width / 3) - 100 : 200,
            padding: const EdgeInsets.all(12),
            color: theme.cardColor.withOpacity(0.7),
            child: BarChart(BarChartData(
              alignment: BarChartAlignment.center,
              barTouchData: BarTouchData(enabled: false),
              borderData:
                  FlBorderData(show: true, border: Border.all(width: 2.0, color: Colors.white.withOpacity(0.4))),
              titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 1, getTitlesWidget: bottomTitles)),
                  leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                    showTitles: true,
                    interval: 5,
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                          axisSide: meta.axisSide, child: Text(meta.formattedValue, style: style.graphTitles));
                    },
                  ))),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                drawHorizontalLine: true,
                horizontalInterval: 1,
                checkToShowHorizontalLine: (value) => value % 2 == 0,
              ),
              barGroups: _generate(ref, width),
            )),
          )
        ],
      ),
    );
  }
}
