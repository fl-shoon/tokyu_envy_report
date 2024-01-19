import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tokyu_envy_report/etc/stream.dart';
import 'package:tokyu_envy_report/repository/auth.dart';
import 'package:tokyu_envy_report/repository/document.dart';
import 'package:tokyu_envy_report/service/service_auth.dart';
import 'package:tokyu_envy_report/service/service_system.dart';
// import 'package:tokyu_envy_report/service/service_visitor.dart';

final initService = Provider((ref) {
  final auth = ref.read(authProvider);
  final document = ref.read(documentProvider);
  final stream = ref.read(streamProvider);

  ServiceSystem(stream);
  ServiceAuth(stream, auth: auth, document: document);
  // ServiceVisitor(stream, document: document);
});
