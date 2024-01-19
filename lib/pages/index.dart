import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tokyu_envy_report/pages/report.dart';
import 'package:tokyu_envy_report/router/router.dart';
import 'package:tokyu_envy_report/router/router_define.dart';

final _routerDelegate = Provider(
  (ref) => ref.read(appRouterGeneratePages)(
    (state) {
      final pages = <Page>[];
      for (var item in state.segments) {
        final name = item.name;
        if (name == RouteLabel.report) pages.add(item.build(const SRport()));
      }
      return pages;
    },
  ),
);

class SIndex extends ConsumerWidget {
  const SIndex({super.key = const Key('s_index')});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(child: Router(routerDelegate: ref.read(_routerDelegate))),
    );
  }
}
