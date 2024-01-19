import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tokyu_envy_report/etc/stream.dart';
import 'package:tokyu_envy_report/saga/saga_initialize.dart';

final initSaga = Provider((ref) {
  final stream = ref.read(streamProvider);

  SagaInitialize(stream);
});
