import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tokyu_envy_report/components/report/axis_widget.dart';
import 'package:tokyu_envy_report/l10n/l10n.dart';
import 'package:tokyu_envy_report/state/state_model.dart';

class VisitorInfoBox extends ConsumerWidget {
  final List<Visitor> todayVisitors;
  final List<Visitor> lastMonthVisitors;
  const VisitorInfoBox({super.key, required this.todayVisitors, required this.lastMonthVisitors});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final mq = MediaQuery.of(context);
    final width = mq.size.width;

    final todayFirstTimers = todayVisitors.where((element) => element.isFirstTime).toList();
    final todayNonFirstTimers = todayVisitors.where((element) => !element.isFirstTime).toList();
    final lastMonthFirstTimers = lastMonthVisitors.where((element) => element.isFirstTime).toList();
    final lastMonthNonFirstTimers = lastMonthVisitors.where((element) => !element.isFirstTime).toList();

    final today = AxisWidget(
        topTitle: l10n.today_visitors,
        leftTitle: l10n.first_time_visitors,
        rightTitle: l10n.non_first_time_visitors,
        topVisitorCountNumber: todayVisitors.length.toString(),
        topVisitorCountText: l10n.count,
        leftVisitorCountNumber: todayFirstTimers.length.toString(),
        leftVisitorCountText: l10n.count,
        rightVisitorCountNumber: todayNonFirstTimers.length.toString(),
        rightVisitorCountText: l10n.count);
    final lastMonth = AxisWidget(
        topTitle: l10n.last_month_visitors,
        leftTitle: l10n.first_time_visitors,
        rightTitle: l10n.non_first_time_visitors,
        topVisitorCountNumber: lastMonthVisitors.length.toString(),
        topVisitorCountText: l10n.count,
        leftVisitorCountNumber: lastMonthFirstTimers.length.toString(),
        leftVisitorCountText: l10n.count,
        rightVisitorCountNumber: lastMonthNonFirstTimers.length.toString(),
        rightVisitorCountText: l10n.count);

    if (width > 480) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [today, const SizedBox(width: 50), lastMonth],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [today, const SizedBox(height: 20), lastMonth],
      );
    }
  }
}
