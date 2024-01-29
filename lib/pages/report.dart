import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tokyu_envy_report/components/survey/question_table.dart';
import 'package:tokyu_envy_report/etc/define.dart';
import 'package:tokyu_envy_report/l10n/l10n.dart';
import 'package:tokyu_envy_report/pages/box/box.dart';
import 'package:tokyu_envy_report/pages/graph/property.dart';
import 'package:tokyu_envy_report/pages/graph/visitor.dart';
import 'package:tokyu_envy_report/pages/pie/pie.dart';
import 'package:tokyu_envy_report/state/state_model.dart';
import 'package:tokyu_envy_report/state/state_visitor.dart';

bool _surveryCheck(List<Visitor> visitors) {
  if (visitors.isEmpty) return false;

  int len = visitors.first.afterAnswers.length;
  final List<bool> boolList = [];

  visitors.asMap().forEach((index, visitor) {
    if (index > 0) {
      boolList.add(len == visitor.afterAnswers.length);
      len = visitor.afterAnswers.length;
    }
  });

  return boolList.every((element) => element == true);
}

class SRport extends ConsumerWidget {
  const SRport({super.key = const Key('s_report')});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final l10n = L10n.of(context)!;
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    final width = mq.size.width;

    final todayVisitors = ref.watch(visitorHistory(DateTime(now.year, now.month, now.day).toIso8601String()));
    final lastMonthVisitors = ref.watch(visitorHistory(DateTime(now.year, now.month - 1).toIso8601String()));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.report_screen, style: theme.textTheme.titleLarge),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(l10n.visitors_basic_info,
                  style: theme.textTheme.titleLarge!
                      .copyWith(decoration: TextDecoration.underline, fontWeight: FontWeight.bold, fontSize: 22)),
              const SizedBox(height: 40),
              VisitorInfoBox(todayVisitors: todayVisitors, lastMonthVisitors: lastMonthVisitors),
              const SizedBox(height: 20),
              const VisitorByMonth(),
              const SizedBox(height: 20),
              const VisitorByProperty(),
              const SizedBox(height: 40),
              Text('先月のアンケート分析',
                  style: theme.textTheme.titleLarge!
                      .copyWith(decoration: TextDecoration.underline, fontWeight: FontWeight.bold, fontSize: 22)),
              const SizedBox(height: 20),
              if (_surveryCheck(lastMonthVisitors) && questions.isNotEmpty) ...[
                const QuestionsTable(),
                const SizedBox(height: 10),
                SurveyPieWidget(visitors: lastMonthVisitors, width: width),
              ],
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
