import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import 'package:rxdart/subjects.dart';
import 'package:tokyu_envy_report/etc/define.dart';

final documentProvider = Provider<Document>((ref) {
  return DocumentFire(
    store: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
  );
});

abstract class Document {
  void awake();
  Future<void> close();

  final roomStream = PublishSubject<List<DocumentData>>();
  void listenRoomList();
  Future<void> notifyVisitorToRoom({required String id, required String visitorId});

  final beaconStream = PublishSubject<List<DocumentData>>();
  void listenBeaconList();

  final visitorStream = PublishSubject<List<DocumentData>>();
  void listenVisitorList();

  Future<String> createVisitor({required Map<String, dynamic> data});
  Future<void> updateVisitor({required String id, required Map<String, dynamic> data});
  Future<void> deleteVisitor({required String id});

  Future<void> admissionVisiter({required String id});
  Future<void> undoVisitor({required String id});
  Future<void> exitVisitor({required String id});
  Future<void> attachFile({
    required String id,
    required Uint8List bytes,
    required String path,
    required String contentType,
  });
  Future<void> deleteAttachedFile({required String id, required String path});

  Future<void> actionForVisitor({required String id, required Map<String, dynamic> data});

  void listenVisitorHistory({required DateTime dateTime});
}

@immutable
class DocumentData {
  final String id;
  final Map<String, dynamic>? data;
  const DocumentData({required this.id, this.data});
}

class DocumentFire extends Document {
  final FirebaseFirestore store;
  final FirebaseStorage storage;

  DocumentFire({
    required this.store,
    required this.storage,
  }) {
    if (!isTesting) {
      if (kIsWeb) {
        /*
        store.enablePersistence(
          const PersistenceSettings(synchronizeTabs: true),
        );
        */
      } else {
        store.settings = const Settings(
          persistenceEnabled: true,
          cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
        );
      }
    }
  }

  Map<String, StreamSubscription> _subs = {};

  @override
  void awake() {
    _subs = {};
  }

  @override
  Future<void> close() async {
    await Future.wait(_subs.values.map((sub) => sub.cancel()));
  }

  static const _dateTimeParams = [
    'createAt',
    'updateAt',
    'admissionAt',
    'exitAt',
    'reserveFrom',
    'reserveTo',
    'timestamp'
  ];
  static const _rooms = 'rooms';
  static const _beacons = 'beacons';
  static const _visitors = 'visitors';
  static const _visitorActions = 'actions';
  static const _visitorRoomActions = 'roomActions';

  Future<DocumentData> _getDaoData(DocumentSnapshot<Map<String, dynamic>> snap) async {
    final id = snap.id;
    final data = snap.data();
    if (data == null) return DocumentData(id: id);

    for (var item in _dateTimeParams) {
      if (data[item] != null) {
        data[item] = (data[item] as Timestamp).toDate();
      }
    }

    final List attachments = data['attachments'] ?? [];
    if (attachments.isNotEmpty) {
      final storageRef = storage.ref();
      final map = <String, String>{};
      for (var value in attachments) {
        map[value] = await storageRef.child(value).getDownloadURL();
      }
      data['attachment_urls'] = map;
    }

    return DocumentData(id: id, data: data);
  }

  @override
  void listenRoomList() {
    if (_subs[_rooms] != null) return;

    final ref = store.collection(_rooms);
    final stream = ref.snapshots();
    _subs[_rooms] = stream.distinct().listen((event) async {
      final list = (await Future.wait(event.docs.map((e) async {
        return await _getDaoData(e);
      })));
      roomStream.add(list);
    });
  }

  @override
  Future<void> notifyVisitorToRoom({required String id, required String visitorId}) async {
    final ref = store.collection(_rooms);
    final data = <String, dynamic>{};
    data['notifyVisitor'] = visitorId;
    data['_notify'] = Random().nextInt(1000000);
    return await ref.doc(id).update(data);
  }

  @override
  void listenBeaconList() async {
    if (_subs[_beacons] != null) return;

    final ref = store.collection(_beacons);
    final stream = ref.snapshots();
    _subs[_beacons] = stream.distinct().listen((event) async {
      final list = (await Future.wait(event.docs.map((e) async {
        return await _getDaoData(e);
      })));
      beaconStream.add(list);
    });
  }

  @override
  void listenVisitorList() async {
    if (_subs[_visitors] != null) return;

    final ref = store.collection(_visitors).where('isActive', isEqualTo: true);
    final stream = ref.snapshots();
    _subs[_visitors] = stream.distinct().listen((event) async {
      final list = (await Future.wait(event.docs.map((e) async {
        return await _getDaoData(e);
      })));
      visitorStream.add(list);
    });
  }

  @override
  Future<String> createVisitor({required Map<String, dynamic> data}) async {
    data['createAt'] = FieldValue.serverTimestamp();
    data['isActive'] = true;
    data['status'] = 0;

    final ref = store.collection(_visitors);
    final snap = await ref.add(data);
    final id = snap.id;
    return id;
  }

  @override
  Future<void> updateVisitor({required String id, required Map<String, dynamic> data}) async {
    final ref = store.collection(_visitors);
    return await ref.doc(id).update(data);
  }

  @override
  Future<void> deleteVisitor({required String id}) async {
    final ref = store.collection(_visitors).doc(id);
    final batch = store.batch();
    final actions = await ref.collection(_visitorActions).get();

    for (var action in actions.docs) {
      batch.delete(action.reference);
    }

    final roomActions = await ref.collection(_visitorRoomActions).get();
    for (var roomAction in roomActions.docs) {
      batch.delete(roomAction.reference);
    }

    await batch.commit();
    return await ref.delete();
  }

  @override
  Future<void> admissionVisiter({required String id}) async {
    final ref = store.collection(_visitors);

    final data = <String, dynamic>{};
    data['admissionAt'] = FieldValue.serverTimestamp();
    data['isActive'] = true;
    data['isShowMessage'] = false;
    data['status'] = 1;
    return await ref.doc(id).update(data);
  }

  @override
  Future<void> undoVisitor({required String id}) async {
    final ref = store.collection(_visitors);

    final data = <String, dynamic>{};
    data['admissionAt'] = FieldValue.delete();
    data['isActive'] = true;
    data['isShowMessage'] = false;
    data['status'] = 0;
    return await ref.doc(id).update(data);
  }

  @override
  Future<void> exitVisitor({required String id}) async {
    final ref = store.collection(_visitors);

    final data = <String, dynamic>{};
    data['exitAt'] = FieldValue.serverTimestamp();
    data['isActive'] = false;
    data['status'] = 100;
    return await ref.doc(id).update(data);
  }

  @override
  Future<void> attachFile(
      {required String id,
      required Uint8List bytes,
      required String path,
      required String contentType,
      required}) async {
    final storageRef = storage.ref();
    final fileRef = storageRef.child('attachments/$id/$path');
    await fileRef.putData(bytes, SettableMetadata(contentType: contentType));

    final ref = store.collection(_visitors);
    return await ref.doc(id).update({
      'attachments': FieldValue.arrayUnion([fileRef.fullPath]),
    });
  }

  @override
  Future<void> deleteAttachedFile({required String id, required String path}) async {
    final storageRef = storage.ref();
    final fileRef = storageRef.child(path);
    await fileRef.delete();

    final ref = store.collection(_visitors);
    return await ref.doc(id).update({
      'attachments': FieldValue.arrayRemove([fileRef.fullPath]),
    });
  }

  @override
  Future<void> actionForVisitor({required String id, required Map<String, dynamic> data}) async {
    final snap = await store.collection(_visitors).doc(id).get();
    if (!snap.exists) return;

    final visitor = snap.data();
    if (visitor == null) return;

    data['timestamp'] = FieldValue.serverTimestamp();
    final ref = store.collection(_visitors).doc(id).collection(_visitorActions);
    await ref.add(data);
  }

  @override
  void listenVisitorHistory({required DateTime dateTime}) {
    final key = dateTime.toIso8601String();
    if (_subs[key] != null) return;

    // FIXME: isActiveを含めると、indexを登録しなければならない
    // https://console.firebase.google.com/v1/r/project/daiyame-44bdf/firestore/indexes?create_composite=Ck5wcm9qZWN0cy9kYWl5YW1lLTQ0YmRmL2RhdGFiYXNlcy8oZGVmYXVsdCkvY29sbGVjdGlvbkdyb3Vwcy92aXNpdG9ycy9pbmRleGVzL18QARoMCghpc0FjdGl2ZRABGg8KC2FkbWlzc2lvbkF0EAEaDAoIX19uYW1lX18QAQ
    final ref = store
        .collection(_visitors) //.where('isActive', isEqualTo: false)
        .where('admissionAt', isGreaterThanOrEqualTo: dateTime)
        .where('admissionAt', isLessThan: dateTime.copyWith(month: dateTime.month + 1));
    final stream = ref.snapshots();
    _subs[key] = stream.distinct().listen((event) async {
      final list = (await Future.wait(event.docs.map((e) async {
        return await _getDaoData(e);
      })));
      visitorStream.add(list);
    });
  }
}
