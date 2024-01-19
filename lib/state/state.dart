import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tokyu_envy_report/state/state_visitor.dart';

final initState = Provider((ref) {
  ref.read(visitorsProvider);
});
