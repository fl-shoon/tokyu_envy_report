import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import 'package:tokyu_envy_report/etc/define.dart';
import 'package:tokyu_envy_report/etc/logger.dart';
import 'package:tokyu_envy_report/etc/stream.dart';
import 'package:tokyu_envy_report/etc/stream_trace.dart';
import 'package:tokyu_envy_report/etc/style.dart';
import 'package:tokyu_envy_report/firebase_options.dart';
import 'package:tokyu_envy_report/l10n/l10n.dart';
import 'package:tokyu_envy_report/pages/index.dart';
import 'package:tokyu_envy_report/pages/login.dart';
import 'package:tokyu_envy_report/router/router.dart';
import 'package:tokyu_envy_report/router/router_define.dart';
import 'package:tokyu_envy_report/saga/saga.dart';
import 'package:tokyu_envy_report/saga/saga_initialize.dart';
import 'package:tokyu_envy_report/service/service.dart';
import 'package:tokyu_envy_report/service/service_system.dart';
import 'package:tokyu_envy_report/state/state.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  setupLogger(disabled: kReleaseMode);
  setUrlStrategy(PathUrlStrategy());

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    const ProviderScope(
      observers: [ProviderLogger()],
      overrides: [],
      child: AppWidget(),
    ),
  );
}

class _Ctrl {
  final ProviderRef ref;
  _Ctrl(this.ref) {
    ref.read(initRouter);
    ref.read(initState);
    ref.read(initService);
    ref.read(initSaga);

    ref.read(streamTrace);

    late StreamSubscription subRouter;
    subRouter = ref.read(streamProvider).whereType<RouterChangedEvent>().listen((event) {
      subRouter.cancel();
      ref.read(streamProvider).add(DoInitialize());
    });

    late StreamSubscription subState;
    subState = ref.read(streamProvider).whereType<DoneInitialize>().listen((event) {
      subState.cancel();
      ref.read(_initializedProvider.notifier).update((state) => true);
      FlutterNativeSplash.remove();
    });
  }
}

final _ctrlProvider = Provider((ref) => _Ctrl(ref));
final _initializedProvider = StateProvider((ref) => false);

class AppWidget extends ConsumerWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(_ctrlProvider);
    ref.watch(_initializedProvider);

    return MaterialApp.router(
      key: const Key('s_main'),
      debugShowCheckedModeBanner: false,
      theme: getTheme(context, Style.light),
      darkTheme: getTheme(context, Style.dark),
      supportedLocales: L10n.supportedLocales,
      localizationsDelegates: L10n.localizationsDelegates,
      localeResolutionCallback: (locale, supportedLocales) {
        late Locale resLocale;
        if (locale == null) {
          resLocale = supportedLocales.first;
        } else {
          resLocale = Locale(locale.languageCode);
          if (!supportedLocales.contains(resLocale)) {
            resLocale = supportedLocales.first;
          }
        }
        Intl.defaultLocale = resLocale.toString();
        ref.read(streamProvider).add(ChangeLanguage(locale: Intl.getCurrentLocale()));
        logger.info('----default locale: ${Intl.getCurrentLocale()}------');

        return resLocale;
      },
      onGenerateTitle: (context) => appName,
      routeInformationParser: ref.read(appRouteInformationParser),
      routerDelegate: ref.read(appRouterGeneratePages)((state) {
        return [
          MaterialPage(
            child: Stack(
              children: [
                Router(routerDelegate: ref.read(_routerDelegate)),
              ],
            ),
          )
        ];
      }),
    );
  }
}

final _routerDelegate = Provider((ref) {
  return ref.read(appRouterGeneratePages)((state) {
    final initialzed = ref.read(_initializedProvider);
    if (!initialzed) {
      return [const MaterialPage(child: Scaffold())];
    }

    final pages = <Page>[];
    for (var item in state.segments) {
      final name = item.name;
      if (name == RouteLabel.login) pages.add(item.build(const SLogin()));
      if (name == RouteLabel.index) pages.add(item.build(const SIndex()));
    }
    return pages;
  });
});
