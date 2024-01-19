import 'dart:async';

import 'package:tokyu_envy_report/service/service_auth.dart';
import 'package:tokyu_envy_report/service/service_system.dart';
import 'package:tokyu_envy_report/etc/stream.dart';
import 'package:flutter/foundation.dart';

@immutable
class DoInitialize extends StreamProcessEvent {}

@immutable
class DoneInitialize extends StreamChangedEvent {
  DoneInitialize(super.process);
}

class SagaInitialize extends SagaBase<DoInitialize> {
  SagaInitialize(super.stream);

  var _initialized = false;

  @override
  void onEvent(DoInitialize event) async {
    if (_initialized) return stream.add(DoneInitialize(event));
    await SagaBase.mutex.acquire();

    stream.add(InitializeSystem(key: event.key));
    stream.transform(StreamTransformer<StreamEvent, StreamEvent>.fromHandlers(handleData: (data, sink) {
      if (data is StreamFailedEvent) {
        sink.close();
      }

      if (data is InitializedSystem) {
        sink.add(InitializeAuth());
      }
      if (data is InitializedAuth) {
        // FIXME: 特に処理なし
      }

      if (data is Signin || data is Signout) {
        sink.add(DoneInitialize(event));
        sink.close();
      }
    })).listen(
      (event) {
        stream.add(event);
      },
      onDone: () {
        _initialized = true;
        SagaBase.mutex.release();
      },
    );
  }
}
