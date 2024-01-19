import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tokyu_envy_report/components/report/axis_widget.dart';
import 'package:tokyu_envy_report/l10n/l10n.dart';
import 'package:tokyu_envy_report/pages/graph/visitor_by_month.dart';

class SRport extends ConsumerWidget {
  const SRport({super.key = const Key('s_report')});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final theme = Theme.of(context);

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
              Text(l10n.visitors_basic_info, style: theme.textTheme.titleMedium),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AxisWidget(
                      topTitle: l10n.current_visitors,
                      leftTitle: l10n.viewing_area,
                      rightTitle: l10n.under_negotiation,
                      //FIXME: ref.watch()にする
                      topVisitorCountNumber: '10',
                      topVisitorCountText: l10n.count,
                      //FIXME: ref.watch()にする
                      leftVisitorCountNumber: '6',
                      leftVisitorCountText: l10n.subject,
                      //FIXME: ref.watch()にする
                      rightVisitorCountNumber: '4',
                      rightVisitorCountText: l10n.subject),
                  const SizedBox(width: 50),
                  AxisWidget(
                      topTitle: l10n.before_visitors,
                      leftTitle: l10n.reservations_today,
                      rightTitle: l10n.reservations_left,
                      //TODO: ref.watch()にする
                      topVisitorCountNumber: '50',
                      topVisitorCountText: l10n.count,
                      //TODO: ref.watch()にする
                      leftVisitorCountNumber: '100',
                      leftVisitorCountText: l10n.subject,
                      //TODO: ref.watch()にする
                      rightVisitorCountNumber: '40',
                      rightVisitorCountText: l10n.subject),
                ],
              ),
              const SizedBox(height: 20),
              const VisitorByMonth(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
