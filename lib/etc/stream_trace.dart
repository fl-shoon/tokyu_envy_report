import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tokyu_envy_report/etc/logger.dart';
import 'package:tokyu_envy_report/etc/stream.dart';
import 'package:tokyu_envy_report/router/router_define.dart';

final streamTrace = Provider((ref) {
  ref
      .read(streamProvider)
      // .debounce((event) => TimerStream(true, const Duration(milliseconds: 100)))
      .listen((event) {
    logger.info('$event uri: ${RouterChangedEvent.currentState.uri.toString()}');
  });
});
