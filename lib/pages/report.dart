import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tokyu_envy_report/components/report/axis_widget.dart';
import 'package:tokyu_envy_report/components/survey/questions_table.dart';
import 'package:tokyu_envy_report/etc/define.dart';
import 'package:tokyu_envy_report/l10n/l10n.dart';
import 'package:tokyu_envy_report/pages/graph/survey/question.dart';
import 'package:tokyu_envy_report/pages/graph/visitor.dart';
import 'package:tokyu_envy_report/state/state_model.dart';
import 'package:tokyu_envy_report/state/state_visitor.dart';

final _visitors = StateProvider.family.autoDispose((ref, String dt) {
  final visitors = ref.watch(visitorHistory(dt));
  return visitors;
});

final _firstTimers = StateProvider.family
    .autoDispose((ref, List<Visitor> visitors) => visitors.where((element) => element.isFirstTime).toList());
final _nonFirstTimers = StateProvider.family
    .autoDispose((ref, List<Visitor> visitors) => visitors.where((element) => !element.isFirstTime).toList());

bool _surveryCheck(List<Visitor> visitors) {
  bool passed = false;
  int len = 0;

  if (visitors.isEmpty) return passed;
  List.generate(visitors.length, (index) {
    len = visitors[index].afterAnswers.length;
    if (index > 0 && visitors[index].afterAnswers.length == len) passed = true;
  });
  return passed;
}

class SRport extends ConsumerWidget {
  const SRport({super.key = const Key('s_report')});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final theme = Theme.of(context);
    final dtNow = DateTime.now();

    final todayVisitors = ref.watch(_visitors(DateTime(dtNow.year, dtNow.month, dtNow.day).toIso8601String()));
    final todayFirstTimers = ref.watch(_firstTimers(todayVisitors));
    final todayNonFirstTimers = ref.watch(_nonFirstTimers(todayVisitors));

    final lastMonthVisitors = ref.watch(_visitors(DateTime(dtNow.year, dtNow.month - 1).toIso8601String()));
    final lastMonthFirstTimers = ref.watch(_firstTimers(lastMonthVisitors));
    final lastMonthNonFirstTimers = ref.watch(_nonFirstTimers(lastMonthVisitors));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.report_screen),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(l10n.visitors_basic_info,
                  style: theme.textTheme.titleLarge!.copyWith(decoration: TextDecoration.underline)),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AxisWidget(
                      topTitle: l10n.today_visitors,
                      leftTitle: l10n.first_time_visitors,
                      rightTitle: l10n.non_first_time_visitors,
                      topVisitorCountNumber: todayVisitors.length.toString(),
                      topVisitorCountText: l10n.count,
                      leftVisitorCountNumber: todayFirstTimers.length.toString(),
                      leftVisitorCountText: l10n.count,
                      rightVisitorCountNumber: todayNonFirstTimers.length.toString(),
                      rightVisitorCountText: l10n.count),
                  const SizedBox(width: 50),
                  AxisWidget(
                      topTitle: l10n.last_month_visitors,
                      leftTitle: l10n.first_time_visitors,
                      rightTitle: l10n.non_first_time_visitors,
                      topVisitorCountNumber: lastMonthVisitors.length.toString(),
                      topVisitorCountText: l10n.count,
                      leftVisitorCountNumber: lastMonthFirstTimers.length.toString(),
                      leftVisitorCountText: l10n.count,
                      rightVisitorCountNumber: lastMonthNonFirstTimers.length.toString(),
                      rightVisitorCountText: l10n.count),
                ],
              ),
              const SizedBox(height: 20),
              const VisitorByMonth(),
              const SizedBox(height: 40),
              Text('先月のアンケート分析', style: theme.textTheme.titleLarge!.copyWith(decoration: TextDecoration.underline)),
              const SizedBox(height: 20),
              if (_surveryCheck(lastMonthVisitors)) ...[
                const QuestionsTable(),
                const SizedBox(height: 10),
                ...List.generate(questions.length, (index) {
                  final check = lastMonthVisitors.first.afterAnswers.length == questions.length;

                  if (check) {
                    if ((index % 2) == 0) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SurveyQuestionPieChart(
                                visitors: lastMonthVisitors, title: '質問${index + 1}', questionIndex: index),
                            SurveyQuestionPieChart(
                                visitors: lastMonthVisitors, title: '質問${index + 2}', questionIndex: index + 1)
                          ]);
                    } else {
                      if ((index + 1).isOdd && (index + 1) == questions.length) {
                        return SurveyQuestionPieChart(
                            visitors: lastMonthVisitors, title: '質問${index + 1}', questionIndex: index);
                      } else {
                        return Container();
                      }
                    }
                  } else {
                    return Container();
                  }
                }),
              ],
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
